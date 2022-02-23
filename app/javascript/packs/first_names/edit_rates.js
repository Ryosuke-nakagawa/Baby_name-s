$(function() {

    $(document).on("click", '#js-edit-sound-rate', function(e) {
        e.preventDefault();
        switchToEdit();
    })

    $(document).on("click", '#js-cancel-sound-rate', function(e) {
        e.preventDefault();
        switchToLabel();
    })

    function switchToEdit() {
        $("#js-edit-sound-rate").hide()
        $("#js-show-sound-rate").hide()
        $("#js-sound-rate-form").show()
        $("#js-cancel-sound-rate").show()
        $("#js-update-sound-rate").show()
    }

    function switchToLabel() {
        $("#js-sound-rate-form").hide()
        $("#js-cancel-sound-rate").hide()
        $("#js-update-sound-rate").hide()
        $("#js-show-sound-rate").show()
        $("#js-edit-sound-rate").show()
    }

    $(document).on("click", '#js-update-sound-rate', function() {
        // clearErrorMessages()
        const rateId = $(this).data('rate-id')
        submitRate($("*[name='rate[sound_rate]']").val(), rateId)
            .then(result => {
                $("#js-show-sound-rate").attr('data-rate', result.rate.sound_rate.toFixed(1))
                switchToLabel()
            })
            .catch(result => {
                const rateId = result.responseJSON.rate.id
                const messages = result.responseJSON.errors.messages
                showErrorMessages(rateId, messages)
            })
    })

    function submitRate(body, rateId) {
        return new Promise(function(resolve, reject) {
            $.ajax({
                type: 'PATCH',
                url: '/rates/' + rateId,
                data: {
                    rate: {
                        sound_rate: body
                    }
                },
                headers: {
                    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
                }
            }).done(function (result) {
                resolve(result)
            }).fail(function (result) {
                reject(result)
            });
        })
    }

})