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

      //show_result(xhr_obj);
      fill_table(xhr_obj);
    });
    element.addEventListener("ajax:error", () => {
        document.querySelector("#table_placer").innerText = "ERROR";
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

function show_result(xhr_obj) {
  const div_place = document.querySelector("#table_placer");
  div_place.innerText = "";
  JSON.parse(xhr_obj.api).forEach (word => {
    const result_table = document.createElement("table");
    div_place.appendChild(result_table);
    const thead = document.createElement("thead");
    const tbody = document.createElement("tbody");
    result_table.appendChild(thead);
    result_table.appendChild(tbody);

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
}

// var ll = function() {
//   const audio_element = document.getElementById('audio_a');
//   audio_element.addEventListener("click", function() {
    
//   });
// }

let fill_table = function (data) {
  const div_place = document.querySelector("#table_placer");
  div_place.innerText = "";
  let own_data = JSON.parse(data.own);
  let api_data = JSON.parse(data.api);

  const result_table = document.createElement("table");
  div_place.appendChild(result_table);
  const thead = document.createElement("thead");
  const tbody = document.createElement("tbody");
  result_table.appendChild(thead);
  result_table.appendChild(tbody);

  const header_row = document.createElement("tr");
  thead.appendChild(header_row);
  header_row.innerText = own_data.phrase + '\t';
  api_data[0].phonetics.forEach ( function(phonetic_variant, index) {
    header_row.innerHTML += `\t[${phonetic_variant.text}]\t`;
    if (phonetic_variant.audio) {
      header_row.innerHTML += `<a id="audio_a${index}"><svg width=\"14\" height=\"16\" viewBox=\"0 0 14 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\
      <path d=\"M13.5 8C13.5 6.23 12.48 4.71 11 3.97V12.02C12.48 11.29 13.5 9.77 13.5 8ZM0 5V11H4L9 16V0L4 5H0Z\" fill=\"black\"/>\
      </svg>\
      <audio id="audio${index}" src="${phonetic_variant.audio}"></audio></a> `;
    }
  });
  for (let i = 0; i < api_data[0].phonetics.length; i++) {
    document.querySelector(`#audio_a${i}`).addEventListener("click", function() {
      let audio = document.getElementById(`audio${i}`);
      audio.play();
    })
  }
    
  

  api_data.forEach (word => {
    

    const result_cell = document.createElement("td");
    const extra_cell = document.createElement("td");
    const name_cell = document.createElement("th");
    result_row.appendChild(name_cell);
    result_row.appendChild(result_cell);
    result_row.appendChild(extra_cell);
    result_cell.innerText = JSON.parse(xhr_obj.own).groups;
    name_cell.innerText = 'Groups';
  });
}

