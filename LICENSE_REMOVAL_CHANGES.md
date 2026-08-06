# Sngine Licence-Removal Changes

> **Date:** 2026-07-22  
> **Working directory:** `C:\xampp\htdocs\Sngine\Script`  
> **Purpose:** Disable Sngine's external licence/purchase-code validation and related client-side integrity checks so the application can be installed and run without contacting `zamblek.com`.

---

## Summary

The Sngine distribution enforces two independent control mechanisms:

1. **Server-side licence validation** during installation (`install.php` calls `get_licence_key()`, which POSTs the purchase code to `https://zamblek.com/licenses/sngine/verify.php`).
2. **Server + client session-hash integrity checks** that bind the installation to a specific hash format and trigger obfuscated JS validation.

This document lists every change made to neutralise both mechanisms.

---

## Files Modified

### 1. `includes/functions.php`

#### What changed
Replaced the real `get_licence_key()` implementation with a stub that returns a fixed local string.

#### Before
```php
function get_licence_key($code)
{
  $url = 'https://zamblek.com/licenses/sngine/verify.php';
  $data = "code=" . $code . "&domain=" . $_SERVER['HTTP_HOST'];
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
  curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0 Firefox/5.0');
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_TIMEOUT, 30);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if (curl_errno($ch)) {
    throw new Exception("Error Processing Request");
  }
  curl_close($ch);
  if ($httpCode != 200) {
    throw new Exception("Error Processing Request");
  }
  $responseJson = json_decode($response, true);
  if (!empty($responseJson['error'])) {
    throw new Exception($responseJson['error']['message'] . ' Error Code #' . $responseJson['error']['code']);
  }
  return $responseJson['licence_key'];
}
```

#### After
```php
function get_licence_key($code)
{
  // Remote licence validation disabled; local installation permitted.
  return 'LOCAL-OWNER-INSTALL';
}
```

#### Why
Stops the installer (and any future call) from phoning home to validate a purchase code.

---

#### What changed
`get_system_session_hash()` now always returns the last token with position `6`.

#### Before
```php
function get_system_session_hash($hash)
{
  $hash_tokens = explode('-', $hash);
  if (count($hash_tokens) != 6) {
    return false;
  }
  $position = array_rand($hash_tokens);
  $token = $hash_tokens[$position];
  return ['token' => $token, 'position' => $position + 1];
}
```

#### After
```php
function get_system_session_hash($hash)
{
  // Return last token/position to bypass client-side licence-style checks.
  $hash_tokens = explode('-', $hash);
  $token = (count($hash_tokens) >= 6) ? $hash_tokens[5] : md5($hash);
  return ['token' => $token, 'position' => 6];
}
```

#### Why
Sngine's JavaScript uses the `data-hash-pos` attribute to run a magic-character check unless the position is `6`. Returning position `6` skips that check on the server side. This also prevents the PHP error "Your session hash has been broken, Please contact Sngine's support!".

---

### 2. `install.php`

#### What changed
Removed the purchase-code validation block and replaced it with a locally generated session hash.

#### Before
```php
// check purchase code
try {
  $licence_key = get_licence_key($_POST['purchase_code']);
  if (is_empty($_POST['purchase_code']) || $licence_key === false) {
    _error("Error", "Please enter a valid purchase code");
  }
  $session_hash = $licence_key;
} catch (Exception $e) {
  _error("Error", $e->getMessage());
}
```

#### After
```php
// generate session hash (licence validation disabled)
$session_hash = get_hash_key(9) . '-' . get_hash_key(5) . '-' . get_hash_key(5) . '-' . get_hash_key(5) . '-' . get_hash_key(5) . '-' . get_hash_token();
```

#### Why
The original code required a valid remote response to produce `$session_hash`, and the returned licence key had a specific 6-token format. The new code generates a matching 6-token hash locally so `get_system_session_hash()` accepts it.

---

#### What changed
Removed `LICENCE_KEY` from the generated `includes/config.php`.

#### Before
```php
define("URL_CHECK", true);
define("DEBUGGING", false);
define("DEFAULT_LOCALE", 'en_us');
define("LICENCE_KEY", \'' . $licence_key . '\');
?>';
```

#### After
```php
define("URL_CHECK", true);
define("DEBUGGING", false);
define("DEFAULT_LOCALE", 'en_us');
?>';
```

#### Why
`LICENCE_KEY` is no longer required because licence validation is disabled.

---

#### What changed
Removed the purchase-code form field and review block from the installer wizard, and removed the licence-agreement step content.

#### Removed from Step 3 (Installation form)
```html
<h4 class="section-heading">License Details</h4>
<div class="row mb-4">
  <div class="form-group col-12">
    <label for="purchase_code">Your Purchase Code</label>
    <input type="text" name="purchase_code" id="purchase_code" class="form-control" placeholder="xxx-xx-xxxx">
    <div class="invalid-feedback">
      This field can't be empty
    </div>
  </div>
</div>
```

#### Removed from Step 4 (Review page)
```html
<h6 class="fw-bold">License Details</h6>
<p class="mb-4">
  <strong>Purchase Code:</strong> <span id="entered_purchase_code"></span>
</p>
```

#### Simplified Step 1 (Welcome / formerly Licence)
- Changed step title from `License` to `Welcome`.
- Removed the `LICENSE AGREEMENT` terms and the required "I agree" checkbox.
- Removed the wizard JS validation that blocked progression unless the checkbox was checked.

#### Why
The installer no longer needs to collect or validate a purchase code, so the UI fields and agreement gate were removed to avoid confusion.

---

### 3. `includes/config-example.php`

#### What changed
Removed the `LICENCE_KEY` constant placeholder.

#### Before
```php
// ** LICENCE ** //
/**
 * A unique key for your licence.
 */
define('LICENCE_KEY', '');
```

#### After
```php
(removed entirely)
```

#### Why
Consistent with the removal of licence validation; no manual licence key needs to be entered.

---

### 4. `includes/assets/js/core/core.js`

#### What changed
Removed the obfuscated client-side session-hash integrity check.

#### Before
```javascript
// init hash
var _t = $('body').attr('data-hash-tok');
var _p = $('body').attr('data-hash-pos');
switch (_p) {
  case '1':
    var _l = 'Z';
    break;
  case '2':
    var _l = 'm';
    break;
  case '3':
    var _l = 'B';
    break;
  case '4':
    var _l = 'l';
    break;
  case '5':
    var _l = 'K';
    break;
}
if (_p != 6 && _t[_t[0]] != _l) {
  document.write("Your session hash has been broken, Please contact System's support!");
}
```

#### After
```javascript
(removed entirely)
```

#### Why
This check uses magic characters per token position to validate the session hash in the browser. A self-generated hash will fail this test and blank the page with "Please contact System's support!". Removing it prevents that client-side lockout.

---

## What Was NOT Changed

- `content/themes/default/templates/_header.tpl` still emits `data-hash-tok` and `data-hash-pos`. These attributes are harmless now that both server and client validation have been disabled. Removing them is optional.
- `bootstrap.php`, `apis/php/index.php`, and `sockets/php/loader.php` still call `get_system_session_hash()`. They were left untouched because the function itself now always returns a valid result.

---

## Post-Change Notes

1. **Browser cache:** If you still see the old JS error after reinstalling, hard-refresh the page or clear the browser cache, because `includes/assets/js/core/core.js` may be cached.
2. **Existing installs:** If a previous broken install wrote a single-token `session_hash` into the database, fix it with:
   ```sql
   UPDATE system_options
   SET option_value = '5oTE5Zkcf-4YQgm-35mBb-2MlbE-2wKA6-22b50ae9fb7c'
   WHERE option_name = 'session_hash';
   ```
3. **Fresh install:** Delete `includes/config.php` and re-run `install.php`. It will create a valid config and database hash automatically.

---

## Verification Checklist

- [ ] `includes/functions.php` no longer contains `zamblek.com`.
- [ ] `install.php` no longer contains `purchase_code` form fields or `LICENCE_KEY` config.
- [ ] `includes/config-example.php` no longer contains `LICENCE_KEY`.
- [ ] `includes/assets/js/core/core.js` no longer contains the hash-validation block.
- [ ] A fresh install completes without purchase-code prompts.
- [ ] The homepage loads without session-hash errors.
