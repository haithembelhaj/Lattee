(function() {

  $(function() {
    var JavaScriptMode, compileSource, hash, sourceFragment, src;
    window.editor = ace.edit("terminal");
    sourceFragment = "lattee:";
    editor.setTheme("ace/theme/solarized_light");
    JavaScriptMode = require("ace/mode/coffee").Mode;
    editor.getSession().setMode(new JavaScriptMode());
    compileSource = function() {
      var source;
      source = editor.getSession().getValue();
      window.compiledJS = '';
      try {
        window.compiledJS = CoffeeScript.compile(source, {
          bare: true
        });
        $('#compiled pre code').html(window.compiledJS);
        $('#compiled pre code').each(function(i, e) {
          return hljs.highlightBlock(e, '    ');
        });
        $('#error').hide();
      } catch (error) {
        $('#error').text(error.message).show();
      }
      $('#share').attr('href', "#" + sourceFragment + (encodeURIComponent(source)));
      return $('#save').attr('href', "data:text/coffeescript;charset=utf-8;base64," + (Base64.encode(source)));
    };
    editor.getSession().on('change', function() {
      return compileSource();
    });
    window.evalJS = function() {
      try {
        console.log('evaluating');
        return eval(window.compiledJS);
      } catch (error) {
        return alert(error);
      }
    };
    window.loadConsole = function(coffee) {
      editor.getSession().setValue(coffee);
      compileSource();
      return false;
    };
    $(document.body).keydown(function(e) {
      if (e.which === 27) closeMenus();
      if (e.which === 13 && (e.metaKey || e.ctrlKey)) return evalJS();
    });
    $('#share').click(function(e) {
      window.location = $(this).attr("href");
      return false;
    });
    $('#run').click(function(e) {
      window.evalJS();
      return false;
    });
    sourceFragment;
    hash = decodeURIComponent(location.hash.replace(/^#/, ''));
    if (hash.indexOf(sourceFragment) === 0) {
      src = hash.substr(sourceFragment.length);
      loadConsole(src);
    }
    return compileSource();
  });

}).call(this);
