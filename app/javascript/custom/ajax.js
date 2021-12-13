// window.addEventListener("load", () => {
//     alert("Hello from ajax.js!")
// })
var word_definitions = {
  "defs": [],
  "pOfSp": [],
  "examples": []
};

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

        const div_place = document.querySelector("#table_placer");
        div_place.innerText = "";
        JSON.parse(xhr_obj.api).forEach (word => {
          const result_table = document.createElement("table");
          div_place.appendChild(result_table);
          const thead = document.createElement("thead");
          const tbody = document.createElement("tbody");
          result_table.appendChild(thead);
          result_table.appendChild(tbody);

          //const result_table = document.querySelector("#search_result");
          //const thead = result_table.tHead;
          //const tbody = result_table.tBodies[0];
          clear_globals();
          thead.innerText = '';
          tbody.innerText = '';
          {
            const result_row = document.createElement("tr");
            thead.appendChild(result_row);
            const result_cell = document.createElement("td");
            const extra_cell = document.createElement("td");
            const name_cell = document.createElement("th");
            result_row.appendChild(name_cell);
            result_row.appendChild(result_cell);
            result_row.appendChild(extra_cell);
            result_cell.innerText = JSON.parse(xhr_obj.own).groups;
            name_cell.innerText = 'Groups';
          }
          get_proper_meaning(word);
          for (let i = 0; i < word_definitions.defs.length; i++) {
            const row = document.createElement("tr");
            tbody.appendChild(row);
            const result_cell = document.createElement("td");
            const example_cell = document.createElement("td");
            const name_cell = document.createElement("th");
            row.appendChild(name_cell);
            row.appendChild(result_cell);
            row.appendChild(example_cell);
            result_cell.innerText = word_definitions.defs[i].definition;
            name_cell.innerText = word_definitions.pOfSp[i];
            example_cell.innerText = word_definitions.examples[i];
          }

        });
        element.addEventListener("ajax:error", () => {
            document.querySelector("#search_result").innerText = "ERROR";
        });
      });
    }
  });
  
function get_proper_meaning(rec) {
  let selected_pos = document.querySelector("#search_part_of_speech").value;
  console.log('REC-POS:');

  rec.meanings.forEach(element => {
    console.log(element.partOfSpeech);

    if (element.partOfSpeech.toUpperCase() === selected_pos.toUpperCase() || selected_pos === "") {
      console.log('REC-DEF:');
      console.log(element.definitions);

      word_definitions.defs.push(element.definitions);
      for (let i = 0; i < element.definitions.length; i++) {
        word_definitions.pOfSp.push(element.partOfSpeech);
        word_definitions.examples.push(element.definitions[i].example || "");
      }
      word_definitions.defs = word_definitions.defs.flat();
    }
  });
}

function clear_globals() {
  word_definitions.defs = [];
  word_definitions.pOfSp = [];
  word_definitions.examples = [];
}