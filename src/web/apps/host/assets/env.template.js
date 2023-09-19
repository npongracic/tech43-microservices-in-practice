(function(window) {  
    window.env = window.env || {};    // Environment variables   
    window["env"]["remoteBasePath"] = "${REMOTE_BASE_PATH}"; 
    window["env"]["sessionUrl"] = "${SESSION_URL}"; 
})(this);