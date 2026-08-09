{if $ads_campaigns}
	<!-- ads campaigns -->
	{foreach $ads_campaigns as $campaign}
		<div class="mb-3 overflow-hidden content {if $campaign['ads_type'] == "post"}bg-transparent{/if}">
			<h6 class="headline-font fw-semibold m-0 side_widget_title d-flex align-items-center justify-content-between gap-3">
				{__("Sponsored")}
				{if $user->_logged_in && $user->_data['user_id'] != $campaign['campaign_user_id']}
					<div class="flex-0 pointer" data-toggle="modal" data-url="data/report.php?do=create&handle=ads_campaign&id={$campaign['campaign_id']}">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" opacity=".7" fill="none"><path d="M5.32171 9.6829C7.73539 5.41196 8.94222 3.27648 10.5983 2.72678C11.5093 2.42437 12.4907 2.42437 13.4017 2.72678C15.0578 3.27648 16.2646 5.41196 18.6783 9.6829C21.092 13.9538 22.2988 16.0893 21.9368 17.8293C21.7376 18.7866 21.2469 19.6548 20.535 20.3097C19.241 21.5 16.8274 21.5 12 21.5C7.17265 21.5 4.75897 21.5 3.46496 20.3097C2.75308 19.6548 2.26239 18.7866 2.06322 17.8293C1.70119 16.0893 2.90803 13.9538 5.32171 9.6829Z" stroke="currentColor" stroke-width="1.75"></path><path d="M11.992 16H12.001" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M12 13L12 8.99997" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"></path></svg>
					</div>
				{/if}
			</h6>
			<div class="px-3 side_item_list pt-1 {if $campaign['campaign_bidding'] == 'click'}js_ads-click-campaign{/if} {if $campaign['ads_type'] == "post"}px-0{/if}" data-id="{$campaign['campaign_id']}">
				{if $campaign['ads_type'] == "post"}
					{include file='__feeds_post.tpl' post=$campaign['ads_post'] standalone=true}
				{else}
					<a href="{$campaign['ads_url']}" target="_blank">
						{if $campaign['ads_image']}
							<img class="img-fluid rounded-3" src="{$system['system_uploads']}/{$campaign['ads_image']}">
						{else}
							<video class="img-fluid mx-auto d-block rounded-3 w-100" src="{$system['system_uploads']}/{$campaign['ads_video']}" autoplay muted loop></video>
						{/if}
					</a>
					{if $campaign['ads_title'] || $campaign['ads_description']}
						<div class="mt-2 pt-1">
							<p class="fw-semibold mb-1">
								<a href="{$campaign['ads_url']}" target="_blank" class="body-color">{$campaign['ads_title']}</a>
							</p>
							<p class="text-muted m-0 small">
								{$campaign['ads_description']|truncate:200}
							</p>
						</div>
					{/if}
				{/if}
			</div>
		</div>
	{/foreach}
	<!-- ads campaigns -->
{/if}