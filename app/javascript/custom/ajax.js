// window.addEventListener("load", () => {
//     alert("Hello from ajax.js!")
// })
var word_definitions = [];

window.addEventListener("load", () => {
    const element = document.getElementById("search_form");
    if (element) {
      element.addEventListener("ajax:success", (event) => {
        const [_data, _status, xhr] = event.detail;
        let xhr_obj = JSON.parse(xhr.response);
        console.log("API:");
        console.log(JSON.parse(xhr_obj.api));
        console.log("DB:");
        console.log(JSON.parse(xhr_obj.own));

        //document.querySelector("#search_result").innerText = xhr.responseText;
        const result_table = document.querySelector("#search_result");
        const thead = result_table.tHead;
        const tbody = result_table.tBodies[0];
        {
          const result_row = document.createElement("th");
          thead.appendChild(result_row);
          const result_cell = document.createElement("td");
          result_row.appendChild(result_cell);
          result_cell.innerText = xhr_obj.own;
        }
        get_proper_meaning(JSON.parse(xhr_obj.api)[0]);
        word_definitions.forEach(def => {
          const result_row = document.createElement("tr");
          tbody.appendChild(result_row);
          const result_cell = document.createElement("td");
          result_row.appendChild(result_cell);
          console.log('result:');
          console.log(word_definitions);
          result_cell.innerText = def.definition;
          //console.log(xhr_obj.api);
        });
        // for (let i = 0; i < 2; i++) {
        //   const result_row = document.createElement("tr");
        //   tbody.appendChild(result_row);
        //   const result_cell = document.createElement("td");
        //   result_row.appendChild(result_cell);
        //   if (i == 1) get_proper_meaning(JSON.parse(xhr_obj.api)[0]);
        //   console.log('result:');
        //   console.log(word_definitions);
        //   result_cell.innerText = i==1 ? word_definitions[0].definition : xhr_obj.own;
        //   //console.log(xhr_obj.api);
        // }
      });
      element.addEventListener("ajax:error", () => {
          document.querySelector("#search_result").innerText = "ERROR";
      });
    }
  });
  
  function get_proper_meaning(rec) {
    let selected_pos = document.querySelector("#search_part_of_speech").value;
    console.log('REC-POS:');

    rec.meanings.forEach(element => {
      console.log(element.partOfSpeech);

      if (element.partOfSpeech == "noun") {
        console.log('REC-DEF:');

        console.log(element.definitions);
        word_definitions = element.definitions;
      }
    });
    // console.log("DDD"); 
    // console.log(result);
    // return result[0];
  }