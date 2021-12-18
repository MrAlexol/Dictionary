window.addEventListener("load", () => {
  const search_form = document.getElementById("search_form");
  if (search_form) {
    search_form.addEventListener("ajax:success", (event) => {
      const [_data, _status, xhr] = event.detail;
      let xhr_obj = JSON.parse(xhr.response);
      console.log(xhr_obj);
      // console.log("API:");
      // console.log(JSON.parse(xhr_obj.api));
      // console.log("DB:");
      // console.log(JSON.parse(xhr_obj.own));
      if (xhr_obj.api && xhr_obj.own)
        fill_table(xhr_obj);
      else
        show_options(xhr_obj);
    });
    search_form.addEventListener("ajax:error", () => {
        document.querySelector("#table_placer").innerText = "ERROR";
    });
  }

  const select = document.querySelector("#search_part_of_speech");
  const input_field = document.querySelector("#search_phrase");
  input_field.addEventListener("change", () => {
    select.innerHTML = '<option value="" label=" "></option>';
  });
});

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
  header_row.innerText = api_data.word + '\t';
  api_data.phonetics.forEach ( function(phonetic_variant, index) {
    header_row.innerHTML += `\t[${phonetic_variant.text}]\t`;
    if (phonetic_variant.audio) {
      header_row.innerHTML += `<a id="audio_a${index}"><svg width=\"14\" height=\"16\" viewBox=\"0 0 14 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\
      <path d=\"M13.5 8C13.5 6.23 12.48 4.71 11 3.97V12.02C12.48 11.29 13.5 9.77 13.5 8ZM0 5V11H4L9 16V0L4 5H0Z\" fill=\"black\"/>\
      </svg>\
      <audio id="audio${index}" src="${phonetic_variant.audio}"></audio></a> `;
    }
  });
  for (let i = 0; i < api_data.phonetics.length; i++) {
    document.querySelector(`#audio_a${i}`)?.addEventListener("click", function() {
      let audio = document.getElementById(`audio${i}`);
      audio.play();
    });
  }

  const groups_row = document.createElement("tr");
  thead.appendChild(groups_row);
  let groups_list = own_data?.groups.split('|');
  groups_list.forEach ( (el) => {
    groups_row.innerHTML += `<span style="background-color: #FF00FF; color: white;">${el}</span>`;
  });
  
  const select = document.querySelector("#search_part_of_speech");

  api_data.meanings.forEach( (meaning) => {
    if (select.innerText.split("\n").indexOf(meaning.partOfSpeech) === -1) {
      let opt = document.createElement('option');
      opt.value = meaning.partOfSpeech;
      opt.innerHTML = meaning.partOfSpeech;
      select.appendChild(opt);
    }
    
    if (meaning.partOfSpeech === select.value || select.value == '') {
      const word_row = document.createElement("tr");
      tbody.appendChild(word_row);
      word_row.innerText = `${api_data.word} (${meaning.partOfSpeech})`;
      
      meaning.definitions.forEach( (definition) => {
        const def_row = document.createElement("tr");
        tbody.appendChild(def_row);
        def_row.innerText = definition.definition;
        if (definition.example) {
          const example_row = document.createElement("tr");
          tbody.appendChild(example_row);
          example_row.innerText = definition.example;
          example_row.style = 'font-style: italic';
        }
      });
    }
  });
}

function show_options(options) {
  const div_place = document.querySelector("#table_placer");
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

