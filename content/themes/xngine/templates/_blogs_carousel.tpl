<div class="mb-3 overflow-hidden content">
	<h6 class="headline-font fw-semibold m-0 side_widget_title">
		{__("Latest Blogs")}
	</h6>
	<div class="px-2 py-1 side_item_list">
		<div id="blogs-carousel" class="carousel slide content rounded-3 p-2" data-bs-ride="carousel">
			<div class="carousel-inner">
				{foreach $latest_blogs as $index => $blog}
					<div class="carousel-item {if $index == 0}active{/if}">
						<a href="{$system['system_url']}/blogs/{$blog['post_id']}/{$blog['blog']['title_url']}" class="body-color">
							<div class="blog-image ratio ratio-4x3 flex-0">
								<img src="{$blog['blog']['parsed_cover']}" class="rounded-3">
							</div>
							<div class="text-truncate mt-2">
								<div class="fw-semibold text-truncate">
									{$blog['blog']['title']}
								</div>
								<p class="m-0 text-muted text-truncate small">
									{$blog['blog']['text_snippet']|truncate:100}
								</p>
							</div>
						</a>
					</div>
				{/foreach}
			</div>
			<button class="carousel-control-prev" type="button" data-bs-target="#blogs-carousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon"></span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#blogs-carousel" data-bs-slide="next">
				<span class="carousel-control-next-icon"></span>
			</button>
		</div>
	</div>
	<a class="main px-3 d-block side_item_hover side_item_list" href="{$system['system_url']}/blogs">
		{__("See All")}
	</a>
</div>