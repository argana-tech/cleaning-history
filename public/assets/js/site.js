var confirmRemove = function(link, message) {
    if (confirm(message)) {
        var f = document.createElement('form');
        f.style.display = 'none';
        link.parentNode.appendChild(f);
        f.method = 'POST';
        f.action = link.href;
        f.submit();
    }
    return false;
}

/**
 * ランダムな文字列を生成
 * @param: 文字列長
 */
var randobet = function(n) {
	var a = 'abcdefghijklmnopqrstuvwxyz'
	+ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	+ '0123456789'
	a = a.split('');
	var s = '';
	for (var i = 0; i < n; i++) {
		s += a[Math.floor(Math.random() * a.length)];
	}
	return s;
};

