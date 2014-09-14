var bound = false;
	
  
	function bindJavascript() {
		var pjs = Processing.getInstanceById('blocks');
		if(pjs!=null) {
			pjs.bindJavascript(this);
			bound = true; 
			}
		if(!bound) setTimeout(bindJavascript, 250);
		}

	bindJavascript();

	function submitScore(score){

		var name;

		if(localStorage && localStorage.name && localStorage.name !== null && localStorage.name !== "null"){
			name = localStorage.name;
		}else{
			var name = prompt("Enter your name:");
			if(localStorage){
				localStorage.name = name;
			}
		}
		
		$.ajax("/submitscore/" + name + "/" + score,{headers: {"isTrue":"true"}});
	}

	function submitToServer(score){

	}

