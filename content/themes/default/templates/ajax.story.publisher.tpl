<div class="creator-story-modal">
  <div class="sng-story-header">
    <div class="sng-story-header-title">
      <div class="sng-story-header-icon">
        <i class="fa fa-plus"></i>
      </div>
      <div>
        <h3>{__("Create New Story")}</h3>
        <small class="text-muted">{__("Share a moment for the next 24 hours")}</small>
      </div>
    </div>
    <button type="button" class="sng-story-close-btn" data-bs-dismiss="modal" aria-label="{__("Close")}">
      <i class="fa fa-times"></i>
    </button>
  </div>

  <form class="publisher-mini" data-error-empty="{__("You must enter some text, or upload a photo or video")}" data-error-generic="{__("There is something that went wrong!")}">
    <div class="sng-story-body">

      {if $user->_is_admin}
        <div class="sng-ads-row">
          <div class="sng-ads-row-icon">
            {include file='__svg_icons.tpl' icon="ads" class="main-icon" width="32px" height="32px"}
          </div>
          <div class="sng-ads-row-text">
            <div class="sng-ads-label">{__("Ads Story")}</div>
            <div class="sng-ads-sub">{__("Share this story as ads so all users see it")}</div>
          </div>
          <label class="switch" for="is_ads">
            <input type="checkbox" name="is_ads" id="is_ads">
            <span class="slider round"></span>
          </label>
        </div>
      {/if}

      <div class="sng-compose-card">
        <input type="hidden" class="js_story-background" value="white">
        <div class="sng-compose-top">
          <img src="{$user->_data['user_picture']}" alt="" class="sng-compose-avatar">
        </div>
        <textarea name="message" maxlength="250" dir="auto" class="js_creator-story-message" placeholder="{__("What is on your mind?")}"></textarea>
        <div class="sng-compose-bottom">
          <div class="sng-color-row" aria-label="{__("Story background")}">
            <button type="button" class="sng-color-circle active" data-color="white" data-background="linear-gradient(135deg,#ffffff,#efebf2)" data-text="#332d37" style="background:#ffffff" aria-label="{__("White")}" aria-pressed="true"></button>
            <button type="button" class="sng-color-circle" data-color="purple" data-background="linear-gradient(135deg,#694ceb,#7e37ac)" data-text="#ffffff" style="background:linear-gradient(135deg,#694ceb,#7e37ac)" aria-label="{__("Purple")}" aria-pressed="false"></button>
            <button type="button" class="sng-color-circle" data-color="pink" data-background="linear-gradient(135deg,#ee2b78,#ff64a4)" data-text="#ffffff" style="background:linear-gradient(135deg,#ee2b78,#ff64a4)" aria-label="{__("Pink")}" aria-pressed="false"></button>
            <button type="button" class="sng-color-circle" data-color="blue" data-background="linear-gradient(135deg,#3788ff,#1ed1e9)" data-text="#ffffff" style="background:linear-gradient(135deg,#3788ff,#1ed1e9)" aria-label="{__("Blue")}" aria-pressed="false"></button>
            <button type="button" class="sng-color-circle" data-color="green" data-background="linear-gradient(135deg,#2dc989,#7ce1a5)" data-text="#18352b" style="background:linear-gradient(135deg,#2dc989,#7ce1a5)" aria-label="{__("Green")}" aria-pressed="false"></button>
            <button type="button" class="sng-color-circle" data-color="sunset" data-background="linear-gradient(135deg,#f96b7e,#fcc25c)" data-text="#382728" style="background:linear-gradient(135deg,#f96b7e,#fcc25c)" aria-label="{__("Sunset")}" aria-pressed="false"></button>
            <button type="button" class="sng-color-circle" data-color="midnight" data-background="linear-gradient(135deg,#271f46,#0a0814)" data-text="#ffffff" style="background:linear-gradient(135deg,#271f46,#0a0814)" aria-label="{__("Midnight")}" aria-pressed="false"></button>
          </div>
          <div class="sng-char-count"><span class="js_creator-story-count">0</span>/250</div>
        </div>
      </div>

      <div class="sng-upload-sections{if !$user->_data['can_upload_videos']} single-col{/if}">
        <div class="sng-upload-box">
          <div class="sng-upload-box-icon"><i class="fa fa-camera"></i></div>
          <h4>{__("Add Photos")}</h4>
          <p>{__("Click to upload")}</p>
          <div class="attachments clearfix" data-type="photos">
            <ul>
              <li class="add">
                <i class="fa fa-camera js_x-uploader" data-handle="publisher-mini" data-multiple="true"></i>
              </li>
            </ul>
          </div>
        </div>

        {if $user->_data['can_upload_videos']}
          <div class="sng-upload-box">
            <div class="sng-upload-box-icon"><i class="fa fa-video"></i></div>
            <h4>{__("Add Videos")}</h4>
            <p>{__("Click to upload")}</p>
            <div class="attachments clearfix" data-type="videos">
              <ul>
                <li class="add">
                  <i class="fa fa-video js_x-uploader" data-type="video" data-handle="publisher-mini" data-multiple="true"></i>
                </li>
              </ul>
            </div>
          </div>
        {/if}
      </div>

      <div class="alert alert-danger mt15 mb0 x-hidden"></div>
    </div>

    <div class="sng-story-footer">
      <button type="button" class="sng-story-cancel-btn" data-bs-dismiss="modal">{__("Cancel")}</button>
      <button type="button" class="sng-story-publish-btn js_publisher-btn js_creator-story-publish">
        <i class="fa fa-paper-plane mr5"></i>{__("Publish Story")}
      </button>
    </div>
  </form>
</div>
