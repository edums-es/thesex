<div class="modal-header">
  <h6 class="modal-title">
    <i class="fa-solid fa-lock me-2 text-primary"></i>{__("Edit exclusive preview")}
  </h6>
  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<form class="js_ajax-forms" data-url="posts/edit.php">
  <div class="modal-body">
    <div class="alert alert-info small">
      {__("Choose the public cover shown to non-subscribers. We permanently blur a separate copy and keep the uploaded source out of the post")}
    </div>
    {if $post['subscriptions_image']}
      <div class="form-label">{__("Current protected preview")}</div>
      <img src="{$system['system_uploads']}/{$post['subscriptions_image']}" class="img-fluid rounded mb-3" alt="">
    {/if}
    <div class="form-group mb-0">
      <label class="form-label">{__("New preview")}</label>
      <div class="x-image">
        <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'></button>
        <div class="x-image-loader">
          <div class="progress x-progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
          </div>
        </div>
        <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image" data-blur></i>
        <input type="hidden" class="js_x-uploader-input" name="subscriptions_image" value="">
      </div>
      <div class="form-text">{__("Use a JPG or PNG image. The original exclusive media is never used as the public preview")}</div>
    </div>
    <div class="alert alert-danger mt-3 mb-0 x-hidden"></div>
  </div>
  <div class="modal-footer">
    <input type="hidden" name="handle" value="subscription_preview">
    <input type="hidden" name="id" value="{$post['post_id']}">
    <button type="button" class="btn btn-light" data-bs-dismiss="modal">{__("Cancel")}</button>
    <button type="submit" class="btn btn-primary">{__("Save protected preview")}</button>
  </div>
</form>
