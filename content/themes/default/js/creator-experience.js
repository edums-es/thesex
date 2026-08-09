/* global $, api, secret, button_status, initialize_uploader, show_error_modal */
(function () {
  "use strict";

  var gradients = {
    white: [[255, 255, 255], [239, 235, 242]],
    purple: [[105, 76, 235], [126, 55, 172]],
    pink: [[238, 43, 120], [255, 100, 164]],
    blue: [[55, 136, 255], [30, 209, 233]],
    green: [[45, 201, 137], [124, 225, 165]],
    sunset: [[249, 107, 126], [252, 194, 92]],
    midnight: [[39, 31, 70], [10, 8, 20]]
  };

  function storyGuid() {
    if (typeof window.guid === "function") {
      return window.guid();
    }
    return "creator_story_" + Date.now() + "_" + Math.random().toString(16).slice(2);
  }

  function hasFiles(value) {
    return value && Object.keys(value).length > 0;
  }

  function showStoryError(publisher, message) {
    var alertBox = publisher.find(".alert.alert-danger");
    if (alertBox.length) {
      alertBox.text(message).stop(true, true).slideDown();
      return;
    }
    if (typeof window.show_error_modal === "function") {
      show_error_modal();
    }
  }

  function wrapText(context, text, maxWidth) {
    var words = text.replace(/\r/g, "").split(/\s+/);
    var lines = [];
    var line = "";

    words.forEach(function (word) {
      var test = line ? line + " " + word : word;
      if (context.measureText(test).width > maxWidth && line) {
        lines.push(line);
        line = word;
      } else {
        line = test;
      }
    });

    if (line) {
      lines.push(line);
    }
    return lines;
  }

  function createTextStory(message, color) {
    return new Promise(function (resolve, reject) {
      var canvas = document.createElement("canvas");
      var context = canvas.getContext("2d");
      var colors = gradients[color] || gradients.pink;
      var fill;
      var brightness;
      var paragraphs;
      var lines = [];
      var lineHeight = 60;
      var startY;

      if (!context) {
        reject(new Error("Canvas is not available"));
        return;
      }

      canvas.width = 600;
      canvas.height = 1000;
      fill = context.createLinearGradient(0, 0, canvas.width, canvas.height);
      fill.addColorStop(0, "rgb(" + colors[0].join(",") + ")");
      fill.addColorStop(1, "rgb(" + colors[1].join(",") + ")");
      context.fillStyle = fill;
      context.fillRect(0, 0, canvas.width, canvas.height);

      brightness = ((((colors[0][0] + colors[1][0]) / 2) * 299) + (((colors[0][1] + colors[1][1]) / 2) * 587) + (((colors[0][2] + colors[1][2]) / 2) * 114)) / 1000;
      context.fillStyle = brightness > 165 ? "#241f27" : "#ffffff";
      context.textAlign = "center";
      context.textBaseline = "middle";
      context.font = "700 42px Poppins, Arial, sans-serif";

      paragraphs = message.split(/\n+/);
      paragraphs.forEach(function (paragraph) {
        lines = lines.concat(wrapText(context, paragraph, canvas.width * 0.78));
      });
      startY = (canvas.height - ((lines.length - 1) * lineHeight)) / 2;
      lines.forEach(function (line, index) {
        context.fillText(line, canvas.width / 2, startY + (index * lineHeight));
      });

      canvas.toBlob(function (blob) {
        if (blob) {
          resolve(blob);
        } else {
          reject(new Error("Could not create story image"));
        }
      }, "image/png", 0.92);
    });
  }

  function uploadTextStory(message, color) {
    return createTextStory(message, color).then(function (blob) {
      var formData = new FormData();
      var filename = "creator_text_story_" + Date.now() + ".png";

      formData.append("secret", secret);
      formData.append("type", "photos");
      formData.append("handle", "publisher-mini");
      formData.append("multiple", "false");
      formData.append("file", blob, filename);
      formData.append("name", filename);
      formData.append("guid", storyGuid());
      formData.append("chunkIndex", "0");
      formData.append("totalChunks", "1");
      formData.append("fileIndex", "0");
      formData.append("totalFiles", "1");

      return $.ajax({
        url: api["data/upload"],
        type: "POST",
        data: formData,
        processData: false,
        contentType: false
      });
    });
  }

  function publishStory(button, publisher, message, photos, videos, isAds) {
    return $.post(api["posts/story"], {
      "do": "publish",
      "is_ads": isAds,
      "message": message,
      "photos": JSON.stringify(photos || {}),
      "videos": JSON.stringify(videos || {})
    }, function (response) {
      button_status(button, "reset");
      if (response && response.callback === "window.location.reload();") {
        window.location.reload();
        return;
      }
      showStoryError(publisher, publisher.data("error-generic"));
    }, "json").fail(function () {
      button_status(button, "reset");
      showStoryError(publisher, publisher.data("error-generic"));
    });
  }

  $(function () {
    $(document)
      .off("click.creatorStoryColor")
      .on("click.creatorStoryColor", ".sng-color-circle", function () {
        var circle = $(this);
        var card = circle.closest(".sng-compose-card");

        card.find(".sng-color-circle").removeClass("active").attr("aria-pressed", "false");
        circle.addClass("active").attr("aria-pressed", "true");
        card.css("background", circle.data("background"));
        card.find("textarea").css("color", circle.data("text"));
        card.find(".js_story-background").val(circle.data("color"));
      });

    $(document)
      .off("input.creatorStoryCounter")
      .on("input.creatorStoryCounter", ".js_creator-story-message", function () {
        $(this).closest(".sng-compose-card").find(".js_creator-story-count").text(this.value.length);
      });

    $(document)
      .off("click.creatorStoryPublish")
      .on("click.creatorStoryPublish", ".js_creator-story-publish", function () {
        var button = $(this);
        var publisher = button.closest(".publisher-mini");
        var message = $.trim(publisher.find(".js_creator-story-message").val() || "");
        var photos = publisher.data("photos") || {};
        var videos = publisher.data("video") || {};
        var color = publisher.find(".js_story-background").val() || "white";
        var isAds = publisher.find("#is_ads").is(":checked");

        publisher.find(".alert.alert-danger").hide();
        if (!message && !hasFiles(photos) && !hasFiles(videos)) {
          showStoryError(publisher, publisher.data("error-empty"));
          return;
        }

        button_status(button, "loading");
        if (hasFiles(photos) || hasFiles(videos)) {
          publishStory(button, publisher, message, photos, videos, isAds);
          return;
        }

        uploadTextStory(message, color).then(function (response) {
          var storyPhotos = {};
          if (!response || typeof response.file !== "string" || !response.file) {
            throw new Error("Story upload did not return a file");
          }
          storyPhotos[response.file] = { source: response.file };
          return publishStory(button, publisher, message, storyPhotos, {}, isAds);
        }).catch(function () {
          button_status(button, "reset");
          showStoryError(publisher, publisher.data("error-generic"));
        });
      });

    $(document).ajaxComplete(function () {
      if ($("#modal .publisher-mini .js_x-uploader").length && typeof window.initialize_uploader === "function") {
        initialize_uploader();
      }
    });
  });
}());
