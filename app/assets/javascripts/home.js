$(document).ready(function(){
  toggleMenu('#item-title');

function toggleMenu(itemID) {
  $('#hidden').click(function(){
    $(itemID).toggleClass('hidden');
  });
};
