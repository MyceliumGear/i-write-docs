var el = document.getElementById("docs-menu");
var hook = el.getElementsByClassName("folder");
var rotated;

for (var i = 0; i < hook.length; i++) {
	hook[i].addEventListener("click",Toogle);
}

function Toogle() {
    'use strict';
  if (this.nextElementSibling.nodeType === 1 && hasClass(this.nextElementSibling,"hide")) { 
    if (this.nextElementSibling.classList) {
      this.nextElementSibling.classList.remove('hide');
    } else {
      this.nextElementSibling.className = this.nextElementSibling.className.replace(new RegExp('(^|\\b)' + "hide" + '(\\b|$)', 'gi'), ' ');
    }
    rotated = false;
  }
  else {    
    this.nextElementSibling.className += " " + "hide";
    rotated = true;
  }
  
  var deg = rotated ? 0 : 180;

  var arrow = this.getElementsByClassName("fa");
  arrow[0].style.transform = 'rotate('+deg+'deg)';     
}

function hasClass (el, className){
  return el.className && new RegExp("(^|\\s)" + className + "(\\s|$)").test(el.className);
}
