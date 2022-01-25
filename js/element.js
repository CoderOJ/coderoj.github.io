function drawSaying() {
  const xhr = new XMLHttpRequest()
  xhr.open('GET', 'https://v1.hitokoto.cn/', true)
  xhr.onreadystatechange = function () {
    if (xhr.readyState == 4 && xhr.status == 200) {
      let res = JSON.parse(xhr.responseText)
      let say = res['hitokoto']
      document.getElementById("saying").innerText = say
    }
  }
  xhr.send()
}

function loadMath() {
  window.MathJax = {
    loader: {
      source: {
        '[tex]/amsCd': '[tex]/amscd',
        '[tex]/AMScd': '[tex]/amscd'
      }
    },
    tex: {
      inlineMath: { '[+]': [['$', '$']] },
      tags: 'ams'
    },
    options: {
      renderActions: {
        findScript: [10, doc => {
          document.querySelectorAll('script[type^="math/tex"]').forEach(node => {
            const display = !!node.type.match(/; *mode=display/);
            const math = new doc.options.MathItem(node.textContent, doc.inputJax[0], display);
            const text = document.createTextNode('');
            node.parentNode.replaceChild(text, node);
            math.start = { node: text, delim: '', n: 0 };
            math.end = { node: text, delim: '', n: 0 };
            doc.math.push(math);
          });
        }, '', false],
        insertedScript: [150, () => {
          document.querySelectorAll('mjx-container').forEach(node => {
            let target = node.parentNode;
            if (target.nodeName.toLowerCase() === 'li') {
              target.parentNode.classList.add('has-jax');
            }
          });
        }, '', false]
      }
    }
  };
  (function () {
    var script = document.createElement('script');
    script.src = '//cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js';
    script.defer = true;
    document.head.appendChild(script);
  })();
}

function verifyPassword(password, sendAlert = true) {
  if (!password) {
    password = document.querySelector("#password").value;
  }

  let ppool = JSON.parse(localStorage.passwd || "{}")
  ppool[window.location.pathname] = password;
  localStorage.passwd = JSON.stringify(ppool);

  const encrypted = document.querySelector("#encrypt-content").innerHTML;
  const key = CryptoJS.SHA256(password);
  const iv = key.create();
  iv.init(key.words.slice(0, 4));

  const decryptedBytes = CryptoJS.AES.decrypt(encrypted, key, { iv, mode: CryptoJS.mode.CBC });
  try {
    const decrypted = CryptoJS.enc.Utf8.stringify(decryptedBytes);
    document.querySelector("article").innerHTML = decrypted;
  } catch (err) {
    if (sendAlert) {
      alert("password incorrect");
      return false
    }
  }

  loadMath()
  hljs.highlightAll()

  return false;
}

function verifyCachedPassword() {
  let ppool = JSON.parse(localStorage.passwd || "{}")
  if (ppool[window.location.pathname]) {
    verifyPassword(ppool[window.location.pathname], false)
  }
}

drawSaying();
