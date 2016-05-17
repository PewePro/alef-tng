function concept_delete(id, url) {

    if (!confirm("Naozaj chcete odstrániť zvolený koncept? Táto akcia je nezvratná.")) {
        return false;
    }

    $.ajax({
        url: url,
        method: 'post',
        data: { '_method': 'delete' }
    }).success(function(){
        $('#concept'+id).slideUp(250);
    }).error(function(){
        alert("Niečo sa pokazilo, prosím skúste to neskôr.")
    });

}