{include file='_head.tpl'}
{include file='_header.tpl'}

<!-- page content -->
<div class="row x_content_row">
	<!-- center panel -->
	<div class="col-lg-8">
		<!-- notifications -->
		<div class="d-flex align-items-center p-3 position-sticky x_top_posts">
			<div class="d-flex align-items-center justify-content-between gap-10 position-relative">
				<span class="headline-font fw-semibold side_widget_title p-0 flex-0">{__("Your Notifications")}</span>

				<span class="flex-0 d-flex align-items-center gap-2 small fw-medium">
					{__("Sound")}
					<label class="switch sm" for="notifications_sound">
						<input type="checkbox" class="js_notifications-sound-toggle" name="notifications_sound" id="notifications_sound" {if $user->_data['notifications_sound']}checked{/if}>
						<span class="slider round"></span>
					</label>
				</span>
			</div>
		</div>
		
		{if $user->_data['notifications']}
			<div class="px-3 py-2">
				<button class="btn btn-sm btn-danger js_delete-all-notifications">
					{__("Delete All")}
				</button>
			</div>
		{/if}
		
		{if $user->_data['notifications']}
			<ul>
				{foreach $user->_data['notifications'] as $notification}
					{include file='__feeds_notification.tpl' _tpl="with-action"}
				{/foreach}
			</ul>

			{if count($user->_data['notifications']) >= $system['max_results']}
				<!-- see-more -->
				<div class="alert alert-post see-more js_see-more" data-get="notifications">
					<span>{__("See More")}</span>
					<div class="loader loader_small x-hidden"></div>
				</div>
				<!-- see-more -->
			{/if}
		{else}
			<!-- no data -->
			<div class="p-3">
				<div class="text-center text-muted py-5">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="56" height="56" color="currentColor" fill="none" opacity="0.5"><path d="M3.92786 9.27697C3.92789 4.84151 7.54419 1.25 12 1.25C16.4558 1.25 20.0721 4.84155 20.0721 9.27703C20.0722 10.3088 20.1416 11.0874 20.6173 11.7873C20.6835 11.8832 20.7712 12.0033 20.8671 12.1345L20.8671 12.1345C21.0337 12.3625 21.2247 12.624 21.3697 12.8505C21.6255 13.2503 21.8754 13.7324 21.9613 14.2942C22.2416 16.127 20.9494 17.3136 19.6625 17.8454C15.1298 19.7182 8.87016 19.7182 4.33746 17.8454C3.05056 17.3136 1.75836 16.127 2.03868 14.2942C2.12459 13.7324 2.37452 13.2503 2.63033 12.8505C2.77528 12.624 2.96636 12.3624 3.13291 12.1345L3.13294 12.1344C3.22882 12.0032 3.31657 11.8831 3.38271 11.7872C3.85838 11.0873 3.92776 10.3087 3.92786 9.27697Z" fill="currentColor"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M7.74341 17.7838C8.27717 17.6419 8.82485 17.9596 8.9667 18.4934C9.30659 19.7724 10.5207 20.7502 12.0002 20.7502C13.4798 20.7502 14.6939 19.7724 15.0338 18.4934C15.1756 17.9596 15.7233 17.6419 16.2571 17.7838C16.7908 17.9256 17.1086 18.4733 16.9667 19.0071C16.3896 21.1786 14.3697 22.7502 12.0002 22.7502C9.63084 22.7502 7.61087 21.1786 7.03379 19.0071C6.89194 18.4733 7.20965 17.9256 7.74341 17.7838Z" fill="currentColor"></path></svg>
					<div class="text-md mt-4">
						<h5 class="headline-font m-0">
							{__("No notifications")}
						</h5>
					</div>
				</div>
			</div>
			<!-- no data -->
		{/if}
		<!-- notifications -->
	</div>
	<!-- center panel -->

	<!-- right panel -->
	<div class="col-lg-4">
		<!-- upgrade to pro -->	
		{if $system['packages_enabled'] && !$user->_data['user_subscribed']}
			<div class="mb-3 overflow-hidden content">
				<h6 class="headline-font fw-semibold m-0 side_widget_title">
					{__("Upgrade to Pro")}
				</h6>
				<div class="px-3 py-0 side_item_list">
					{__("Choose the Plan That's Right for You")}
				</div>
				<div class="px-3 side_item_list">
					<a class="btn btn-main" href="{$system['system_url']}/packages">
						{__("Upgrade")}
					</a>
				</div>
			</div>
		{/if}
		<!-- upgrade to pro -->
		
		{include file='_ads_campaigns.tpl'}
		{include file='_ads.tpl'}
		{include file='_widget.tpl'}
		
		<!-- mini footer -->
		{include file='_footer_mini.tpl'}
		<!-- mini footer -->
	</div>
	<!-- right panel -->
</div>
<!-- page content -->

{include file='_footer.tpl'}