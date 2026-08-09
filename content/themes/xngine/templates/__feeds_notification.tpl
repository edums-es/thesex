{if $_tpl == "with-action"}
	<li class="feeds-item feeds-action-item {if !$notification['seen']}unread{/if}" data-id="{$notification['notification_id']}">
		<div class="px-3 side_item_hover d-flex align-items-center justify-content-between side_item_list gap-3 x_notification">
			<a class="d-flex align-items-center x_user_info body-color" href="{$notification['url']}" {if $notification['action'] == "mass_notification"}target="_blank" {/if}>
				<div class="position-relative flex-0">
					<img src="{$notification['user_picture']}" alt="{$notification['name']}" class="rounded-circle large">
					<div class="position-absolute bg-white rounded-circle text-center x_action_icon">
						{if $notification['reaction']}
							<div class="reaction-btn">
								<div class="reaction-btn-icon">
									<div class="inline-emoji no_animation">
										{include file='__reaction_emojis.tpl' _reaction=$notification['reaction']}
									</div>
								</div>
							</div>
						{else}
							<i class="{$notification['icon']} main"></i>
						{/if}
					</div>
				</div>

				<div class="flex-1 mx-2 px-1">
					<div>
						<span class="name fw-semibold">{$notification['name']}</span>
						{if !$notification['system_notification'] && $notification['user_verified']}
							<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
								<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
							</span>
						{/if}
						{if !$notification['system_notification'] && $notification['user_subscribed']}
							<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
								<svg xmlns="http://www.w3.org/2000/svg" height="17" viewBox="0 0 24 24" width="17"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg>
							</span>
						{/if}
						<span>{$notification['message']}</span>
					</div>
					<div class="time small opacity-50 js_moment" data-time="{$notification['time']}">{$notification['time']}</div>
				</div>
			</a>
			<div class="flex-0">
				<button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn p-2 border-0 rounded-circle btn-gray js_notification-deleter text-danger" data-id="{$notification['notification_id']}">
					<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns:xlink="http://www.w3.org/1999/xlink"><path d="M19.5 5.5L18.8803 15.5251C18.7219 18.0864 18.6428 19.3671 18.0008 20.2879C17.6833 20.7431 17.2747 21.1273 16.8007 21.416C15.8421 22 14.559 22 11.9927 22C9.42312 22 8.1383 22 7.17905 21.4149C6.7048 21.1257 6.296 20.7408 5.97868 20.2848C5.33688 19.3626 5.25945 18.0801 5.10461 15.5152L4.5 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M9 11.7349H15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M10.5 15.6543H13.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path><path d="M3 5.5H21M16.0555 5.5L15.3729 4.09173C14.9194 3.15626 14.6926 2.68852 14.3015 2.39681C14.2148 2.3321 14.1229 2.27454 14.0268 2.2247C13.5937 2 13.0739 2 12.0343 2C10.9686 2 10.4358 2 9.99549 2.23412C9.89791 2.28601 9.80479 2.3459 9.7171 2.41317C9.32145 2.7167 9.10044 3.20155 8.65842 4.17126L8.05273 5.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"></path></svg>
				</button>
			</div>
		</div>
	</li>
{else}
	<li class="feeds-item {if !$notification['seen']}unread{/if}" data-id="{$notification['notification_id']}">
		<a class="px-3 side_item_hover side_item_list d-flex align-items-center x_user_info body-color x_notification" href="{$notification['url']}" {if $notification['action'] == "mass_notification"}target="_blank" {/if}>
			<div class="position-relative flex-0">
				<img src="{$notification['user_picture']}" alt="{$notification['name']}" class="rounded-circle large">
				<div class="position-absolute bg-white rounded-circle text-center x_action_icon">
					{if $notification['reaction']}
						<div class="reaction-btn">
							<div class="reaction-btn-icon">
								<div class="inline-emoji no_animation">
									{include file='__reaction_emojis.tpl' _reaction=$notification['reaction']}
								</div>
							</div>
						</div>
					{else}
						<i class="{$notification['icon']} main"></i>
					{/if}
				</div>
			</div>

			<div class="flex-1 mx-2 px-1">
				<div>
					<span class="name fw-semibold">{$notification['name']}</span>
					{if !$notification['system_notification'] && $notification['user_verified']}
						<span class="verified-badge" data-bs-toggle="tooltip" title='{__("Verified User")}'>
							<svg xmlns="http://www.w3.org/2000/svg" width="17" height="17" enable-background="new 0 0 24 24" viewBox="0 0 24 24"><path fill="currentColor" d="M23,12l-2.44-2.79l0.34-3.69l-3.61-0.82L15.4,1.5L12,2.96L8.6,1.5L6.71,4.69L3.1,5.5L3.44,9.2L1,12l2.44,2.79l-0.34,3.7 l3.61,0.82L8.6,22.5l3.4-1.47l3.4,1.46l1.89-3.19l3.61-0.82l-0.34-3.69L23,12z M9.38,16.01L7,13.61c-0.39-0.39-0.39-1.02,0-1.41 l0.07-0.07c0.39-0.39,1.03-0.39,1.42,0l1.61,1.62l5.15-5.16c0.39-0.39,1.03-0.39,1.42,0l0.07,0.07c0.39,0.39,0.39,1.02,0,1.41 l-5.92,5.94C10.41,16.4,9.78,16.4,9.38,16.01z"></path></svg>
						</span>
					{/if}
					{if !$notification['system_notification'] && $notification['user_subscribed']}
						<span class="pro-badge" data-bs-toggle="tooltip" title='{__("Pro User")}'>
							<svg xmlns="http://www.w3.org/2000/svg" height="17" viewBox="0 0 24 24" width="17"><path d="M0 0h24v24H0z" fill="none"></path><path fill="currentColor" d="M12 2.02c-5.51 0-9.98 4.47-9.98 9.98s4.47 9.98 9.98 9.98 9.98-4.47 9.98-9.98S17.51 2.02 12 2.02zm-.52 15.86v-4.14H8.82c-.37 0-.62-.4-.44-.73l3.68-7.17c.23-.47.94-.3.94.23v4.19h2.54c.37 0 .61.39.45.72l-3.56 7.12c-.24.48-.95.31-.95-.22z"></path></svg>
						</span>
					{/if}
					<span>{$notification['message']}</span>
				</div>
			</div>
		</a>
	</li>
{/if}