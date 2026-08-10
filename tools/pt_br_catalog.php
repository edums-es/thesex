<?php

declare(strict_types=1);

use Gettext\Generator\MoGenerator;
use Gettext\Generator\PoGenerator;
use Gettext\Loader\PoLoader;
use Gettext\Translation;

require dirname(__DIR__) . '/vendor/autoload.php';

const PT_BR_PO = __DIR__ . '/../content/languages/locale/pt_br/LC_MESSAGES/messages.po';
const PT_BR_MO = __DIR__ . '/../content/languages/locale/pt_br/LC_MESSAGES/messages.mo';
const PT_BR_OVERRIDES = __DIR__ . '/../includes/pt_br_overrides.php';

function fail(string $message): never
{
  fwrite(STDERR, $message . PHP_EOL);
  exit(1);
}

function mask_protected_fragments(string $text): array
{
  $tokens = [];
  $pattern = '~(<[^>]+>|https?://[^\s<>]+|%(?:\d+\$)?[-+0-9\'.]*[bcdeEfFgGosuxX]|\{\{[^}]+\}\}|\{[^}]+\}|&(?:[A-Za-z][A-Za-z0-9]+|#[0-9]+|#x[0-9A-Fa-f]+);)~u';
  $masked = preg_replace_callback($pattern, static function (array $match) use (&$tokens): string {
    $token = sprintf('ZXPH%04dZX', count($tokens));
    $tokens[$token] = $match[0];
    return $token;
  }, $text);

  return [$masked ?? $text, $tokens];
}

function restore_protected_fragments(string $text, array $tokens): ?string
{
  foreach ($tokens as $token => $value) {
    if (!str_contains($text, $token)) {
      return null;
    }
    $text = str_replace($token, $value, $text);
  }
  return $text;
}

function placeholders(string $text): array
{
  preg_match_all('~%(?:\d+\$)?[-+0-9\'.]*[bcdeEfFgGosuxX]|\{\{[^}]+\}\}|\{[^}]+\}|<[^>]+>~u', $text, $matches);
  $values = $matches[0] ?? [];
  sort($values);
  return $values;
}

function normalize_machine_translation(string $id, string $translation): string
{
  /* Product terminology: the platform consistently uses "publicação", not
   * the literal "postagem" returned by generic machine translation. */
  $translation = str_replace(
    ['Postagens', 'postagens', 'Postagem', 'postagem', 'Blogues', 'blogues', 'Blogue', 'blogue', 'Por favor, tente outro', 'Linkedin'],
    ['Publicações', 'publicações', 'Publicação', 'publicação', 'Blogs', 'blogs', 'Blog', 'blog', 'Tente novamente', 'LinkedIn'],
    $translation
  );

  /* Sngine's Jobs module is a classifieds board, so "vaga" is clearer than
   * the literal employment/work variants. */
  if (preg_match('/\bJobs?\b/i', $id)) {
    $translation = str_replace(
      ['Postos de trabalho', 'postos de trabalho', 'Empregos', 'empregos', 'Emprego', 'emprego', 'Trabalhos', 'trabalhos', 'Trabalho', 'trabalho'],
      ['Vagas', 'vagas', 'Vagas', 'vagas', 'Vaga', 'vaga', 'Vagas', 'vagas', 'Vaga', 'vaga'],
      $translation
    );
  }

  if (preg_match('/\bStor(?:y|ies)\b/i', $id)) {
    $translation = str_replace(
      ['Histórias', 'histórias', 'História', 'história'],
      ['Stories', 'stories', 'Story', 'story'],
      $translation
    );
  }

  /* "Ticket" normally means a support request in Sngine. Event admission
   * strings are explicitly excluded and reviewed in the overlay. */
  if (preg_match('/\bTickets?\b/i', $id) && !in_array($id, ['Tickets Link', 'Please enter a valid tickets link', 'For example: Subscribe, Get tickets, Preorder now or Shop now'], true)) {
    $translation = str_replace(
      ['Ingressos', 'ingressos', 'Ingresso', 'ingresso', 'Tíquetes', 'tíquetes', 'Tíquete', 'tíquete', 'Bilhetes', 'bilhetes', 'Bilhete', 'bilhete', 'Tickets', 'tickets', 'Ticket', 'ticket'],
      ['Chamados', 'chamados', 'Chamado', 'chamado', 'Chamados', 'chamados', 'Chamado', 'chamado', 'Chamados', 'chamados', 'Chamado', 'chamado', 'Chamados', 'chamados', 'Chamado', 'chamado'],
      $translation
    );
  }

  return $translation;
}

function catalog(): Gettext\Translations
{
  return (new PoLoader())->loadFile(PT_BR_PO);
}

function literal_source_messages(): array
{
  $root = dirname(__DIR__);
  $messages = [];
  $extensions = ['php' => true, 'tpl' => true, 'js' => true];
  $skip = ['vendor/', 'content/languages/', 'content/cache/', 'node_modules/', '.git/', 'mods e addons/'];
  $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($root, FilesystemIterator::SKIP_DOTS));

  foreach ($iterator as $file) {
    if (!$file->isFile() || !isset($extensions[strtolower($file->getExtension())])) {
      continue;
    }
    $relative = str_replace('\\', '/', substr($file->getPathname(), strlen($root) + 1));
    foreach ($skip as $prefix) {
      if (str_starts_with($relative, $prefix)) {
        continue 2;
      }
    }
    $contents = (string) file_get_contents($file->getPathname());
    preg_match_all('~__\(\s*"((?:\\\\.|[^"\\\\])*)"\s*\)~s', $contents, $doubleQuoted);
    foreach ($doubleQuoted[1] as $value) {
      $messages[stripcslashes($value)] = $relative;
    }
    preg_match_all("~__\\(\\s*'((?:\\\\.|[^'\\\\])*)'\\s*\\)~s", $contents, $singleQuoted);
    foreach ($singleQuoted[1] as $value) {
      $messages[str_replace(["\\'", "\\\\"], ["'", "\\"], $value)] = $relative;
    }
  }
  return $messages;
}

function export_source(string $target): void
{
  $entries = [];
  foreach (catalog() as $translation) {
    if ($translation->isDisabled() || $translation->getOriginal() === '') {
      continue;
    }
    [$masked, $tokens] = mask_protected_fragments($translation->getOriginal());
    $entries[] = [
      'id' => $translation->getOriginal(),
      'masked' => $masked,
      'tokens' => $tokens,
    ];
  }

  $json = json_encode($entries, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  if ($json === false || file_put_contents($target, $json) === false) {
    fail('Could not export translation source to ' . $target);
  }
  echo 'Exported ' . count($entries) . ' active messages' . PHP_EOL;
}

function apply_catalog(string $source): void
{
  $raw = (string) file_get_contents($source);
  $decoded = json_decode(ltrim($raw, "\xEF\xBB\xBF"), true);
  if (!is_array($decoded)) {
    fail('Invalid translated JSON: ' . $source);
  }

  $machine = [];
  foreach ($decoded as $row) {
    if (!isset($row['id'], $row['translation']) || !is_string($row['id']) || !is_string($row['translation'])) {
      continue;
    }
    [, $tokens] = mask_protected_fragments($row['id']);
    $restored = restore_protected_fragments(trim($row['translation'], "\r\n"), $tokens);
    if ($restored !== null && placeholders($row['id']) === placeholders($restored)) {
      $machine[$row['id']] = $restored;
    }
  }

  $translations = catalog();
  $applied = 0;
  foreach ($translations as $translation) {
    $id = $translation->getOriginal();
    if ($translation->isDisabled() || $id === '' || !isset($machine[$id])) {
      continue;
    }
    $translation->translate(normalize_machine_translation($id, $machine[$id]));
    $translation->getFlags()->delete('fuzzy');
    $applied++;
  }

  $reviewed = require PT_BR_OVERRIDES;
  foreach ($reviewed as $id => $value) {
    $translation = $translations->find('', $id);
    if ($translation === null) {
      $translation = Translation::create(null, $id);
      $translations->add($translation);
    }
    $translation->translate($value);
    $translation->getFlags()->delete('fuzzy');
  }

  $headers = $translations->getHeaders();
  $headers->set('Language', 'pt_BR');
  $headers->set('Language-Team', 'Português do Brasil');
  $headers->set('Last-Translator', 'The Sex localization review');
  $headers->set('PO-Revision-Date', date('Y-m-d H:iO'));
  $headers->set('X-Generator', 'The Sex PT-BR catalog pipeline');
  $headers->setPluralForm(2, '(n > 1)');

  (new PoGenerator())->generateFile($translations, PT_BR_PO);
  (new MoGenerator())->includeHeaders()->generateFile($translations, PT_BR_MO);
  echo sprintf('Applied %d machine drafts and %d reviewed translations', $applied, count($reviewed)) . PHP_EOL;
}

function audit_catalog(): void
{
  $translations = catalog();
  $stats = [
    'active' => 0,
    'translated' => 0,
    'missing' => 0,
    'same_as_english' => 0,
    'disabled' => 0,
    'fuzzy' => 0,
    'placeholder_mismatches' => 0,
  ];
  $mismatches = [];

  foreach ($translations as $translation) {
    if ($translation->getOriginal() === '') {
      continue;
    }
    if ($translation->isDisabled()) {
      $stats['disabled']++;
      continue;
    }
    if ($translation->getFlags()->has('fuzzy')) {
      $stats['fuzzy']++;
    }
    $stats['active']++;
    $value = (string) $translation->getTranslation();
    if ($value === '') {
      $stats['missing']++;
      continue;
    }
    $stats['translated']++;
    if ($value === $translation->getOriginal()) {
      $stats['same_as_english']++;
    }
    if (placeholders($translation->getOriginal()) !== placeholders($value)) {
      $stats['placeholder_mismatches']++;
      $mismatches[] = $translation->getOriginal();
    }
  }

  $sourceMessages = literal_source_messages();
  $sourceMissing = [];
  foreach ($sourceMessages as $id => $file) {
    if ($translations->find('', $id) === null) {
      $sourceMissing[$id] = $file;
    }
  }
  ksort($sourceMissing);

  echo json_encode([
    'stats' => $stats,
    'source_literal_keys' => count($sourceMessages),
    'source_keys_missing_from_catalog' => count($sourceMissing),
    'source_missing_sample' => array_slice($sourceMissing, 0, 50, true),
    'placeholder_mismatches' => array_slice($mismatches, 0, 50),
  ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . PHP_EOL;
}

$command = $argv[1] ?? 'audit';
if ($command === 'export') {
  export_source($argv[2] ?? fail('Missing export target'));
} elseif ($command === 'apply') {
  apply_catalog($argv[2] ?? fail('Missing translated JSON path'));
} elseif ($command === 'audit') {
  audit_catalog();
} else {
  fail('Usage: php tools/pt_br_catalog.php [audit|export <json>|apply <json>]');
}
