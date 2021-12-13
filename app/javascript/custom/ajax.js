// window.addEventListener("load", () => {
//     alert("Hello from ajax.js!")
// })

window.addEventListener("load", () => {
    const element = document.getElementById("search_form");
    if (element) {
      element.addEventListener("ajax:success", (event) => {
        const [_data, _status, xhr] = event.detail;
        document.querySelector("#search_result").innerText = xhr.responseText;
      });
      element.addEventListener("ajax:error", () => {
          document.querySelector("#search_result").innerText = "ERROR";
      });
    }
  });
  