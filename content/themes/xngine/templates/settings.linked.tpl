<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Linked Accounts")}
	</div>
</div>


<div class="p-3 pt-1">
	{if $system['apple_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				<svg width="30" height="30" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 6.25C12 4.25 13.5 2.25 15.5 2.25C15.5 4.25 14 6.25 12 6.25Z" fill="currentColor"/><path d="M12.5 7.59001C11.9851 7.59001 11.5867 7.42646 11.1414 7.24368C10.5776 7.01225 9.93875 6.75 8.89334 6.75C7.02235 6.75 4 8.24945 4 12.2495C4 16.9016 7.10471 21.75 9.10471 21.75C9.77426 21.75 10.3775 21.4871 10.954 21.2359C11.4815 21.0059 11.9868 20.7857 12.5 20.7857C13.0132 20.7857 13.5185 21.0059 14.046 21.2359C14.6225 21.4871 15.2257 21.75 15.8953 21.75C17.2879 21.75 18.9573 19.3992 20 16.4008C18.3793 15.7202 17.338 14.118 17.338 12.25C17.338 10.621 18.2036 9.53982 19.5 8.75C18.5 7.25 17.0134 6.75 15.9447 6.75C14.8993 6.75 14.2604 7.01225 13.6966 7.24368C13.2514 7.42646 13.0149 7.59001 12.5 7.59001Z" fill="currentColor"/></svg>
			</div>
			<div>
				<div class="form-label mb0">{__("Apple")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['facebook_connected']}
						{__("Your account is connected to")} {__("Apple")}
					{else}
						{__("Connect your account to")} {__("Apple")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['facebook_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/apple">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/apple">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['google_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="google" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Google")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['google_connected']}
						{__("Your account is connected to")} {__("Google")}
					{else}
						{__("Connect your account to")} {__("Google")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['google_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/google">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/google">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}
	
	{if $system['facebook_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="facebook" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Facebook")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['facebook_connected']}
						{__("Your account is connected to")} {__("Facebook")}
					{else}
						{__("Connect your account to")} {__("Facebook")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['facebook_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/facebook">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/facebook">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['twitter_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="x" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Twitter")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['twitter_connected']}
						{__("Your account is connected to")} {__("Twitter")}
					{else}
						{__("Connect your account to")} {__("Twitter")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['twitter_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/twitter">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/twitter">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}
	
	{if $system['discord_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="discord" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Discord")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['twitter_connected']}
						{__("Your account is connected to")} {__("Discord")}
					{else}
						{__("Connect your account to")} {__("Discord")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['twitter_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/discord">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/discord">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['linkedin_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="linkedin" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Linkedin")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['linkedin_connected']}
						{__("Your account is connected to")} {__("Linkedin")}
					{else}
						{__("Connect your account to")} {__("Linkedin")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['linkedin_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/linkedin">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/linkedin">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['vkontakte_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="vk" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Vkontakte")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['vkontakte_connected']}
						{__("Your account is connected to")} {__("Vkontakte")}
					{else}
						{__("Connect your account to")} {__("Vkontakte")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['vkontakte_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/vkontakte">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/vkontakte">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['wordpress_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				{include file='__svg_icons.tpl' icon="wordpress" width="30px" height="30px"}
			</div>
			<div>
				<div class="form-label mb0">{__("Wordpress")}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['wordpress_connected']}
						{__("Your account is connected to")} {__("wordpress")}
					{else}
						{__("Connect your account to")} {__("wordpress")}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['wordpress_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/wordpress">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="{$system['system_url']}/connect/wordpress">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}

	{if $system['sngine_login_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div class="avatar align-self-center">
				<img src="{$system['system_uploads']}/{$system['sngine_app_icon']}" width="30" height="30" alt="{__({$system['sngine_app_name']})}">
			</div>
			<div>
				<div class="form-label mb0">{__({$system['sngine_app_name']})}</div>
				<div class="form-text d-none d-sm-block mt0">
					{if $user->_data['sngine_connected']}
						{__("Your account is connected to")} {__({$system['sngine_app_name']})}
					{else}
						{__("Connect your account to")} {__({$system['sngine_app_name']})}
					{/if}
				</div>
			</div>
			<div class="text-end align-self-center flex-0">
				{if $user->_data['sngine_connected']}
					<a class="btn btn-sm btn-danger" href="{$system['system_url']}/revoke/sngine">{__("Disconnect")}</a>
				{else}
					<a class="btn btn-sm btn-primary" href="https://{$system['sngine_app_domain']}/api/oauth?app_id={$system['sngine_appid']}">{__("Connect")}</a>
				{/if}
			</div>
		</div>
	{/if}
</div>