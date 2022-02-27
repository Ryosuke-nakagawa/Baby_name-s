$(function() {

    $(document).on("click", '#js-edit-rate', function(e) {
        e.preventDefault();
        const rateType = $(this).data('rate-type')
        switchToEdit(rateType);
    })

    $(document).on("click", '#js-cancel-rate', function(e) {
        e.preventDefault();
        const rateType = $(this).data('rate-type')
        switchToLabel(rateType);
    })

    function switchToEdit(rateType) {

        $("#js-show-" + rateType + "-rate").hide()
        $("#js-edit-" + rateType + "-rate").show()
    }

    function switchToLabel(rateType) {
        $("#js-edit-" + rateType + "-rate").hide()
        $("#js-show-" + rateType + "-rate").show()
    }

    $(document).on("click", '#js-update-rate', function() {
        // clearErrorMessages()
        const rateId = $(this).data('rate-id')
        const rateType = $(this).data('rate-type')
        const formName = `*[name='rate[${rateType}_rate]']`
        submitRate($(formName).val(), rateType, rateId)
            .then(result => {
                if (rateType === 'sound') {
                    $('#js-star-sound-rate').attr('data-rate', result.rate.sound_rate.toFixed(1))
                    $('#js-star-sound-rate-ave').attr('data-rate', result.sound_rate_ave.toFixed(1))
                    switchToLabel(rateType)
                }else if (rateType === 'character') {
                    $("#js-star-character-rate").attr('data-rate', result.rate.character_rate.toFixed(1))
                    $('#js-star-character-rate-ave').attr('data-rate', result.character_rate_ave.toFixed(1))
                    switchToLabel(rateType)
                }
            })
            .catch(result => {
                const messages = result.responseJSON.errors.messages
                showErrorMessages(messages)
            })
    })

    function submitRate(body, rateType, rateId) {
        return new Promise(function(resolve, reject) {
            let rate = {};
            rate[rateType + '_rate'] = body

            $.ajax({
                type: 'PATCH',
                url: '/rates/' + rateId,
                data: { rate },
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