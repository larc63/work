var bench = new Benchmark('insertNode',
 
// The function to test
function() {
  mydiv.insertAdjacentHTML('beforeend', '<span></span>');
},
 
// Additional options for the test
{
  'setup': function() {
    var mydiv = document.getElementById('mydiv');
  },
  'teardown': function() {
    mydiv.innerHTML = '';
  }
});