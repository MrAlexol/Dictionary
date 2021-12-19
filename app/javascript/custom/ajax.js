const Rails = require("@rails/ujs");

window.addEventListener("load", () => {
  const search_form = document.getElementById("search_form");
  if (search_form) {
    window.addEventListener("ajax:success", (event) => { // для работы при переходе при помощи navbar
      const [_data, _status, xhr] = event.detail;
      let xhr_obj = JSON.parse(xhr.response);
      console.log(xhr_obj);
      // console.log("API:");
      // console.log(JSON.parse(xhr_obj.api));
      // console.log("DB:");
      // console.log(JSON.parse(xhr_obj.own));

      if (xhr_obj.api && xhr_obj.own) {
        let own_data = JSON.parse(xhr_obj.own);
        let api_data = JSON.parse(xhr_obj.api);
        if (Array.isArray(api_data))
          fill_table(own_data, api_data);
        else
          show_options({});
      }
      else
        show_options(xhr_obj);
    });
    search_form.addEventListener("ajax:error", () => {
        document.querySelector("#table_placer").innerText = "Sorry, AJAX doesn't work";
    });
  }

  const select = document.querySelector("#search_part_of_speech");
  const input_field = document.querySelector("#search_phrase");
  input_field.addEventListener("change", () => {
    select.innerHTML = '<option value="all">all</option>';
  });
});

let fill_table = function (own_data, api_data) {
  const div_place = document.querySelector("#table_placer");
  div_place.innerText = "";
  
  let input_field = document.querySelector("#search_phrase");
  input_field.value = api_data[0].word;

  api_data.forEach ( (word, word_index) => { 
    if (word.word.toLowerCase() !== input_field.value.toLowerCase()) {
      return;
    }
    const result_table = document.createElement("table");
    result_table.id = `result_table${word_index}`;
    div_place.appendChild(result_table);
    const thead = document.createElement("thead");
    const tbody = document.createElement("tbody");
    result_table.appendChild(thead);
    result_table.appendChild(tbody);

    const header_row = document.createElement("tr");
    thead.appendChild(header_row);
    header_row.innerText = word.word + '\t';
    word.phonetics.forEach ( function(phonetic_variant, index) {
      header_row.innerHTML += `\t[${phonetic_variant.text}]\t`;
      if (phonetic_variant.audio) {
        header_row.innerHTML += `<a id="audio_a${word_index}_${index}"><svg width=\"14\" height=\"16\" viewBox=\"0 0 14 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\
        <path d=\"M13.5 8C13.5 6.23 12.48 4.71 11 3.97V12.02C12.48 11.29 13.5 9.77 13.5 8ZM0 5V11H4L9 16V0L4 5H0Z\" fill=\"black\"/>\
        </svg>\
        <audio id="audio${word_index}_${index}" src="${phonetic_variant.audio}"></audio></a> `;
      }
    });
    for (let i = 0; i < word.phonetics.length; i++) {
      document.querySelector(`#audio_a${word_index}_${i}`)?.addEventListener("click", function() {
        let audio = document.getElementById(`audio${word_index}_${i}`);
        audio.play();
      });
    }

    const groups_row = document.createElement("tr");
    thead.appendChild(groups_row);
    let groups_list = own_data?.groups?.split('|');
    groups_list?.forEach ( (el) => {
      groups_row.innerHTML += `<span style="background-color: #FF00FF; color: white;">${el}</span>`;
    });
    
    const select = document.querySelector("#search_part_of_speech");

    word.meanings.forEach( (meaning, meaning_index) => {
      if (select.innerText.split("\n").indexOf(meaning.partOfSpeech) === -1) {
        let opt = document.createElement('option');
        opt.value = meaning.partOfSpeech;
        opt.innerHTML = meaning.partOfSpeech;
        select.appendChild(opt);
      }
      
      if (meaning.partOfSpeech === select.value || select.value == "all") {
        const word_row = document.createElement("tr");
        tbody.appendChild(word_row);
        word_row.innerText = `${word.word} (${meaning.partOfSpeech})`;
        word_row.id = `word_row_${word_index}_${meaning_index}`
        meaning.definitions.forEach( (definition, def_index) => {
          const def_row = document.createElement("tr");
          tbody.appendChild(def_row);
          def_row.innerText = definition.definition;
          def_row.id = `def_row_${word_index}_${meaning_index}_${def_index}`;
          def_row.classList += "word_definition";
          def_row.addEventListener("click", () => {add_link(word_index, meaning_index, def_index); return false; });
          
          // add_link(word_index, meaning_index, def_row);
          if (definition.example) {
            const example_row = document.createElement("tr");
            tbody.appendChild(example_row);
            example_row.innerText = definition.example;
            example_row.style = 'font-style: italic';
          }
        });
      }
    });
    if (tbody.innerHTML === "") { // удалим пустые таблицы. Такие могут появляться при фильтрации по части речи
      result_table.remove();
    }
  });
}

function show_options(options) {
  const div_place = document.querySelector("#table_placer");
  if (Object.keys(options).length > 0) {
    div_place.innerText = "Maybe you meant:";
    for (const key of Object.keys(options)) {    
      const option = document.createElement("div");
      div_place.appendChild(option);
      option.innerText = key;
      option.addEventListener("click", () => {
        document.querySelector("#search_phrase").value = option.innerText;
        document.querySelector("#search_submit").click();
      })
    }
  }
  else {
    div_place.innerText = "Nothing was found";
  }
}

function add_link(word_index, meaning_index, def_index) {
  let word_el = document.querySelector(`#word_row_${word_index}_${meaning_index}`);
  let def_el = document.querySelector(`#def_row_${word_index}_${meaning_index}_${def_index}`);

  let svg_ok = '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">\
  <path d="M9 16.17L4.83 12L3.41 13.41L9 19L21 7L19.59 5.59L9 16.17Z" fill="black"/>\
  </svg>';

  let mydata = `card[word]=${word_el.innerText}&card[definition]=${def_el.innerText}`;
  Rails.ajax({
    type: "POST", 
    url: "/cards",
    data: mydata,
    success: function(repsonse){ def_el.innerHTML += svg_ok; },
    error: function(repsonse){ alert("ERR") }
  })
}