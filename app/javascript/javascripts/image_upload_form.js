$(document).on('turbolinks:load', function() {
  $('.custom-file-input').on('change', handleFileSelect);
  function handleFileSelect(evt) {
    $('#atached-images').remove();
    $('#preview').remove();
    $(this).parents('.input-group').after('<div id="preview"></div>');
  
    var files = evt.target.files;
    var selected_files = 0;
  
    for (var i = 0, f; f = files[i]; i++) {
      var size_in_megabytes = f.size/1024/1024;

      if (size_in_megabytes > 5) {
        alert("ファイルサイズ5MB以下の画像を選択してください。");
        break;
      }
  
      var reader = new FileReader();
  
      reader.onload = (function(theFile) {
        return function(e) {
          var $html = ['<div class="d-inline-block mr-1 mt-1"><img class="img-thumbnail" src="', e.target.result,'" title="', escape(theFile.name), '" style="height:100px;" /><div class="small text-muted text-center">', escape(theFile.name),'</div></div>'].join('');

          $('#preview').append($html);
        };
      })(f);
  
      reader.readAsDataURL(f);
      selected_files ++
    }

    if (selected_files > 0) {
      $(this).next('.custom-file-label').html(selected_files + '個のファイルを選択しました');
    }
  }
  
  //ファイルの取消
  $('.reset').click(function(){
    $(this).parent().prev().children('.custom-file-label').html('ファイル選択...');
    $('#preview').remove();
    $('.custom-file-input').val('');
  })
});
