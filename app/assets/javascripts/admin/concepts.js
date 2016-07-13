function concept_learning_objects(id, name) {

    var template = doT.template($('#concepts-learning-objects-template').html());

    NProgress.start();

    $.getJSON('/admin/concepts/'+id+'/learning_objects', function(learning_objects){
        vex.open({ content: template({ name: name, learning_objects: learning_objects }) });
        NProgress.done();
    });

}

/**
 * Odstrani priradenie otazky ku konceptu.
 * @param id [Integer] ID vazobnej entity medzi konceptom a otazkou
 * */
function concept_lo_delete(id) {

    if (!confirm("Naozaj chcete odstrániť prepojenie medzi vzdelávacím objektom a konceptom?")) {
        return false;
    }

    $.ajax({
        url: '/admin/concepts/delete_learning_object',
        method: 'post',
        data: { '_method': 'delete', learning_object_id: id }
    }).success(function(){
        $('#concept-learning-object'+id).slideUp(250);
    }).error(function(){
        alert("Niečo sa pokazilo, prosím skúste to neskôr.")
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