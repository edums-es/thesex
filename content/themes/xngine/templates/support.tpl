{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
.search-wrapper-prnt {
display: none !important
}
</style>

<div class="row x_content_row">
	<div class="col-lg-12 w-100">
		<div class="position-sticky x_top_posts">
			<div class="headline-font fw-semibold side_widget_title px-3 py-2 d-flex align-items-center justify-content-between">
				<span class="py-2">{__("Support Center")}</span>
				<span class="flex-0 d-flex align-items-center gap-2">
					{if !$user->_is_admin && !$user->_is_moderator}
						{if $view == "new"}
							<a href="{$system['system_url']}/support/tickets" class="btn btn-sm flex-0">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg> <span class="my2">{__("Tickets")}</span>
							</a>
						{else}
							<a class="btn btn-sm btn-primary flex-0 d-none d-md-flex" href="{$system['system_url']}/support/tickets/new">
								<span class="my2">{__("Create Ticket")}</span>
							</a>
							<a class="btn btn-primary flex-0 p-2 rounded-circle lh-1 d-md-none" href="{$system['system_url']}/support/tickets/new">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C12.5523 3 13 3.44772 13 4V11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H13V20C13 20.5523 12.5523 21 12 21C11.4477 21 11 20.5523 11 20V13H4C3.44772 13 3 12.5523 3 12C3 11.4477 3.44772 11 4 11H11V4C11 3.44772 11.4477 3 12 3Z" fill="currentColor"/></svg>
							</a>
						{/if}
					{/if}
				</span>
			</div>
		</div>
		
		{if $view == "" || $view == "tickets" || $view == "find"}
			<div class="pt-3 pb-2 px-2 mx-1">
				<form action="{$system['system_url']}/support/tickets/find" method="get">
					<div class="position-relative">
						<input type="search" class="form-control shadow-none rounded-pill x_search_filter" name="query" placeholder='{__("Search by Subject or TicketID")}' value="{$query}">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="18" height="18" color="currentColor" fill="none" class="position-absolute pe-none search-input-icon"><path d="M17.5 17.5L22 22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M20 11C20 6.02944 15.9706 2 11 2C6.02944 2 2 6.02944 2 11C2 15.9706 6.02944 20 11 20C15.9706 20 20 15.9706 20 11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"></path></svg>
					</div>
				</form>
			</div>
		{/if}
		
		{if $view == "ticket"}
			<div class="p-3">
				<div class="row">
					<div class="col-lg-4 col-xl-3">
						<div class="mb-3 overflow-hidden content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title">
								{__("Ticket Details")}
							</h6>
							
							<div class="p-3 pt-2 side_item_list">
								<!-- requester -->
								<div>
									<div class="mb-2 fw-medium">{__("Requester")}</div>
									<div>
										<a target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}">
											<img class="tbl-image" src="{$ticket['requester_picture']}">
											{$ticket['requester_fullname']}
										</a>
									</div>
								</div>
								<!-- requester -->
								
								<hr>
								
								<!-- agent -->
								<div>
									<div class="mb-2 fw-medium">{__("Agent")}</div>
									<div>
										{if $ticket['agent_id']}
											{if $user->_is_admin || $user->_is_moderator}
												<a target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}">
													<img class="tbl-image" src="{$ticket['agent_picture']}">
													{$ticket['agent_fullname']}
												</a>
											{else}
												{__("Support Agent")}
											{/if}
										{else}
											<span class="badge rounded-pill bg-light text-primary">{__("Unassigned")}</span>
										{/if}
									</div>
								</div>
								<!-- agent -->
								
								<hr>
								
								<!-- status -->
								<div>
									<div class="mb-1 fw-medium">{__("Status")}</div>
									<div>
										{if $ticket['status'] == "opened"}
											<span class="badge rounded-pill bg-primary">{__("Opened")}</span>
										{elseif $ticket['status'] == "in_progress"}
											<span class="badge rounded-pill bg-info">{__("In Progress")}</span>
										{elseif $ticket['status'] == "pending"}
											<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
										{elseif $ticket['status'] == "solved"}
											<span class="badge rounded-pill bg-success">{__("Solved")}</span>
										{elseif $ticket['status'] == "closed"}
											<span class="badge rounded-pill bg-danger">{__("Closed")}</span>
										{/if}
									</div>
								</div>
								<!-- status -->
								
								<hr>
								
								<!-- last update -->
								<div>
									<div class="mb-1 fw-medium">{__("Last Update")}</div>
									<div class="small">
										<span class="js_moment" data-time="{$ticket['updated_at']}">{$ticket['updated_at']}</span>
									</div>
								</div>
								<!-- last update -->
								
								<hr>
								
								<!-- created at -->
								<div>
									<div class="mb-1 fw-medium">{__("Created At")}</div>
									<div class="small">
										<span class="js_moment" data-time="{$ticket['created_at']}">{$ticket['created_at']}</span>
									</div>
								</div>
								<!-- created at -->
								
								{if $user->_is_admin || $user->_is_moderator}
									<div class="mt-3">
										<button class="btn btn-dark w-100" data-toggle="modal" data-url="support/ticket.php?do=update&ticket_id={$ticket['ticket_id']}">
											{__("Update")}
										</button>
									</div>
								{/if}
							</div>
						</div>
					</div>
				
					<div class="col-lg-8 col-xl-9">
						<div class="">
							<h3 class="m-0 fw-semibold headline-font">{$ticket['subject']}</h3>
						</div>
						
						<!-- ticket -->
						<div class="d-flex justify-content-between x_user_info post-header mt-3">
							<div class="d-flex position-relative mw-0">
								<!-- picture -->
								<div class="post-avatar position-relative flex-0">
									<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$ticket['requester_username']}" style="background-image:url({$ticket['requester_picture']});"></a>
								</div>
								<!-- picture -->
								<div class="mw-0 mx-2">
									<div class="post-meta">
										<!-- author -->
										<span>
											<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$ticket['requester_username']}">{$ticket['requester_fullname']}</a>
										</span>
										<span class="text-muted small">
											<i class="fa fa-user"></i> {__("Member")}
										</span>
										<!-- author -->

										<div class="post-time text-muted">
											<span class="js_moment" data-time="{$ticket['created_at']}">{$ticket['created_at']}</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="d-flex mb-3">
							<div class="post_empty_space flex-0"></div>
							<div class="flex-1">
								<div class="text">
									{$ticket['parsed_text']}
								</div>
							</div>
						</div>
						<!-- ticket -->

						<!-- replies -->
						{if $ticket['replies']}
							{foreach $ticket['replies'] as $reply}
								<div class="forum-thread pt-3">
									<div class="d-flex justify-content-between x_user_info post-header">
										<div class="d-flex position-relative mw-0">
											<!-- picture -->
											<div class="post-avatar position-relative flex-0">
												{if $user->_is_admin || $user->_is_moderator}
													<a class="post-avatar-picture rounded-circle overflow-hidden d-block" href="{$system['system_url']}/{$reply['user_name']}" style="background-image:url({$reply['user_picture']});"></a>
												{else}
													<a class="post-avatar-picture rounded-circle overflow-hidden d-block" style="background-image:url({$reply['user_picture']});"></a>
												{/if}
											</div>
											<!-- picture -->
											<div class="mw-0 mx-2">
												<div class="post-meta">
													<!-- author -->
													<span>
														{if $user->_is_admin || $user->_is_moderator}
															<a class="post-author fw-semibold body-color" href="{$system['system_url']}/{$reply['user_name']}">{$reply['user_fullname']}</a>
														{else}
															<a class="post-author fw-semibold body-color">{$reply['user_fullname']}</a>
														{/if}
													</span>
													{if $user->_is_admin || $user->_is_moderator}
														<span class="text-muted small">
															{if $reply['user_group'] == 1}
																<i class="fa fa-shield-alt"></i> {__("Admin")}
															{elseif $reply['user_group'] == 2}
																<i class="fab fa-black-tie"></i> {__("Moderator")}
															{else}
																<i class="fa fa-user"></i> {__("Member")}
															{/if}
														</span>
													{/if}
													<!-- author -->

													<div class="post-time text-muted">
														<span class="js_moment" data-time="{$reply['created_at']}">{$reply['created_at']}</span>
													</div>
												</div>
											</div>
										</div>
									</div>

									<div class="d-flex">
										<div class="post_empty_space flex-0"></div>
										<div class="flex-1">
											<div class="text">
												{$reply['parsed_text']}
											</div>
										</div>
									</div>
								</div>
							{/foreach}
						{/if}
						<!-- replies -->

						<!-- reply form -->
						<div class="p-3 content">
							<h6 class="headline-font fw-semibold m-0 side_widget_title px-0 pt-0">
								{__("Post Reply")}
							</h6>
							
							<div class="js_ajax-forms-html" data-url="support/ticket.php?do=reply&id={$ticket['ticket_id']}">
								<div class="form-floating">
									<textarea name="text" class="form-control js_wysiwyg" placeholder=" "></textarea>
								</div>

								<!-- error -->
								<div class="alert alert-danger mt15 mb0 x-hidden"></div>
								<!-- error -->
								
								<hr class="hr-2">

								<div class="text-end">
									<button type="submit" class="btn btn-primary">{__("Submit")}</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		{else}
			{if $view == "" || $view == "tickets" || $view == "find"}
				<div class="px-3 pt-3">
					<div class="pb-3 headline-font fw-semibold h4 m-0">
						{__("Tickets")} {if $view == "find"} &rsaquo; {__("Search")}{/if}
					</div>
				</div>
				
				<!-- categories -->
				<div class="pb-2">
					<div class="overflow-hidden x_page_cats x_page_scroll d-flex align-items-start position-relative">
						<ul class="px-3 d-flex gap-2 align-items-center overflow-x-auto pb-3 scrolll">
							<li {if $view == "" || $view == "tickets" && !$status && !$unassigned}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets" class="btn btn-sm">
									{__("All")} ({$tickets_stats['total']})
								</a>
							</li>
							{if $user->_is_admin}
								<li {if $unassigned}class="position-relative main main_bg_half" {/if}>
									<a href="{$system['system_url']}/support/tickets?unassigned=true" class="btn btn-sm">
										{__("Unassigned")} ({$tickets_stats['unassigned']})
									</a>
								</li>
								<li class="py-1"><div class="vr"></div></li>
							{/if}
							<li {if $status == "in_progress"}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets?status=in_progress" class="btn btn-sm">
									{__("In Progress")} ({$tickets_stats['in_progress']})
								</a>
							</li>
							<li {if $status == "opened"}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets?status=opened" class="btn btn-sm">
									{__("Open")} ({$tickets_stats['opened']})
								</a>
							</li>
							<li {if $status == "pending"}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets?status=pending" class="btn btn-sm">
									{__("Pending")} ({$tickets_stats['pending']})
								</a>
							</li>
							<li {if $status == "solved"}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets?status=solved" class="btn btn-sm">
									{__("Solved")} ({$tickets_stats['solved']})
								</a>
							</li>
							<li {if $status == "closed"}class="position-relative main main_bg_half" {/if}>
								<a href="{$system['system_url']}/support/tickets?status=closed" class="btn btn-sm">
									{__("Closed")} ({$tickets_stats['closed']})
								</a>
							</li>
						</ul>
						<div class="d-flex align-items-center justify-content-between position-absolute w-100 h-100 pe-none scroll-btns">
							<div class="pe-auto">
								<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-left-btn">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15 6L9 12.0001L15 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
								</button>
							</div>
							<div class="pe-auto">
								<button class="btn rounded-circle p-1 bg-black text-white mx-2 scroll-right-btn">
									<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M9.00005 6L15 12L9 18" stroke="currentColor" stroke-width="2" stroke-miterlimit="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
								</button>
							</div>
						</div>
					</div>
				</div>
				<!-- categories -->
			
				<div class="px-3 pt-2">
					<div class="table-responsive">
						<table class="table table-striped table-bordered table-hover">
							<thead>
								<tr>
									<th class="fw-semibold bg-transparent">{__("ID")}</th>
									<th class="fw-semibold bg-transparent">{__("Subject")}</th>
									<th class="fw-semibold bg-transparent">{__("Agent")}</th>
									<th class="fw-semibold bg-transparent">{__("Status")}</th>
									<th class="fw-semibold bg-transparent">{__("Last Update")}</th>
								</tr>
							</thead>
							<tbody>
								{if $tickets}
									{foreach $tickets as $ticket}
										<tr>
											<td class="bg-transparent">{$ticket['ticket_id']}</td>
											<td class="bg-transparent">
												<a href="{$system['system_url']}/support/tickets/{$ticket['ticket_id']}" title="{$ticket['subject']}" class="fw-semibold">{$ticket['subject']|truncate:30}</a>
												<div class="small mt-2">
													<a target="_blank" href="{$system['system_url']}/{$ticket['requester_username']}" class="body-color">
														<img class="tbl-image" src="{$ticket['requester_picture']}">
														{$ticket['requester_fullname']}
													</a>
												</div>
											</td>
											<td class="bg-transparent">
												{if $ticket['agent_id']}
													{if $user->_is_admin || $user->_is_moderator}
														<a target="_blank" href="{$system['system_url']}/{$ticket['agent_username']}">
															<img class="tbl-image" src="{$ticket['agent_picture']}">
															{$ticket['agent_fullname']}
														</a>
													{else}
														{__("Support Agent")}
													{/if}
												{else}
													<span class="badge rounded-pill bg-light text-primary">{__("Unassigned")}</span>
												{/if}
											</td>
											<td class="bg-transparent">
												{if $ticket['status'] == "opened"}
													<span class="badge rounded-pill bg-primary">{__("Opened")}</span>
												{elseif $ticket['status'] == "in_progress"}
													<span class="badge rounded-pill bg-info">{__("In Progress")}</span>
												{elseif $ticket['status'] == "pending"}
													<span class="badge rounded-pill bg-warning">{__("Pending")}</span>
												{elseif $ticket['status'] == "solved"}
													<span class="badge rounded-pill bg-success">{__("Solved")}</span>
												{elseif $ticket['status'] == "closed"}
													<span class="badge rounded-pill bg-danger">{__("Closed")}</span>
												{/if}
											</td>
											<td class="bg-transparent">
												<span class="js_moment" data-time="{$ticket['updated_at']}">{$ticket['updated_at']}</span>
											</td>
										</tr>
									{/foreach}
								{else}
									<tr>
										<td colspan="6" class="text-center bg-transparent">
											{__("No data to show")}
										</td>
									</tr>
								{/if}
							</tbody>
						</table>
					</div>
					{$pager}
				</div>
			{/if}
			
			{if $view == "new"}
				<div class="p-3">
					<div class="pb-3 headline-font fw-semibold h4 m-0">
						{__("Create New Ticket")}
					</div>
				
					<div class="js_ajax-forms-html" data-url="support/ticket.php?do=create">
						<div class="form-floating">
							<input class="form-control" name="subject" placeholder=" ">
							<label class="form-label">{__("Subject")}</label>
						</div>

						<div class="form-floating">
							<textarea name="text" class="form-control js_wysiwyg" placeholder=" "></textarea>
						</div>

						<!-- error -->
						<div class="alert alert-danger mt15 mb0 x-hidden"></div>
						<!-- error -->
						
						<hr class="hr-2">

						<div class="text-end">
							<button type="submit" class="btn btn-primary">{__("Submit")}</button>
						</div>
					</div>
				</div>
			{/if}
		{/if}
	</div>
</div>

{include file='_footer.tpl'}