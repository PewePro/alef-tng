function concept_questions(id, name) {

    var template = doT.template($('#concepts-questions-template').html());

    $.getJSON('/admin/concepts/'+id+'/questions', function(resp){
        vex.open({ content: template({ name: name, questions: resp }) });
    });

}

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