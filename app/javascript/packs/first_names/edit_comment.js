$(function() {

  $(document).on("click", '.js-edit-comment-button', function(e) {
    e.preventDefault();
    const commentId = $(this).data("comment-id")
    switchToEdit(commentId)
  })

  $(document).on("click", '.js-button-edit-comment-cancel', function() {
    clearErrorMessages()
    const commentId = $(this).data("comment-id")
    switchToLabel(commentId)
  })

  $(document).on("click", '.js-button-comment-update', function() {
    clearErrorMessages()
    const commentId = $(this).data("comment-id")
    submitComment($("#js-textarea-comment-" + commentId).val(), commentId)
    .then(result => {
      switchToLabel(result.comment.id)
      $("#js-comment-" + result.comment.id).html(result.comment.body.replace(/\r?\n/g, '<br>'))
    })
    .catch(result => {
      const commentId = result.responseJSON.comment.id
      const messages = result.responseJSON.errors.messages
      showErrorMessages(commentId, messages)
    })
  })

  function switchToLabel(commentId) {
    $("#js-textarea-comment-box-" + commentId).hide()
    $("#js-comment-" + commentId).show()
  }

  function switchToEdit(commentId) {
    $("#js-comment-" + commentId).hide()
    $("#js-textarea-comment-box-" + commentId).show()
  }

  function showErrorMessages(commentId, messages) {
    $('<p class="error_messages text-danger">' + messages.join('<br>') + '</p>').insertBefore($("#js-textarea-comment-" + commentId))
  }

  function submitComment(body, commentId) {
    return new Promise(function(resolve, reject) {
      //  ajax通信条件にCSRFトークンを入れる
      set_csrftoken()
      $.ajax({
        type: 'PATCH',
        url: '/comments/' + commentId,
        data: {
            comment: {
                body: body
            }
        }
      }).done(function (result) {
        resolve(result)
      }).fail(function (result) {
        reject(result)
      });
    })
  }

  function clearErrorMessages() {
    $("p.error_messages").remove()
  }

  function set_csrftoken() {
    $.ajaxPrefilter(function (options, originalOptions, jqXHR) {
      if (!options.crossDomain) {
        const token = $('meta[name="csrf-token"]').attr('content');
        if (token) {
          return jqXHR.setRequestHeader('X-CSRF-Token', token);
        }
      }
    });
  }
});