let characters = [];

window.addEventListener("message", (event) => {
  const data = event.data;

  if (!data) return;

  // console.log(JSON.stringify(data));

  if (data.action === "open") {
    if (!event.data) return;

    characters = data.data;
    document.body.style.display = "block";

    const characterButtons = document.getElementsByClassName("character");
    Array.from(characterButtons).forEach((character, index) => {
      if (!characters[index]) {
        character.disabled = true;

        return;
      }

      const characterData = characters[index];
      character.addEventListener("click", () => {
        // console.log("moijn");
        document.getElementById("delete").style.display = "block";
        // console.log(JSON.stringify(characterData));
        // CharacterPressed(characterData.character_id);
      });

      character.addEventListener("dblclick", () => {
        // console.log("dblclick");
        document.getElementById("delete").style.display = "none";
        // document.getElementById("delete").style.display = "block";
        // console.log(JSON.stringify(characterData));
        CharacterPressed(characterData.character_id);
      });

      document.getElementById("delete").addEventListener("click", () => {
        // console.log(JSON.stringify(characterData));
        document.getElementById("delete").style.display = "none";
        CharacterDelete(characterData.character_id);
      });

      character.innerText =
        characterData.firstname + " " + characterData.lastname;
      character.disabled = false;

      character.addEventListener("mouseover", () => {
        document.getElementById("firstname").innerText =
          "Firstname: " + characterData.firstname;
        document.getElementById("lastname").innerText =
          "Lastname: " + characterData.lastname;
        document.getElementById("age").innerText = "Age: " + characterData.age;
        document.getElementById("job").innerText = "Job: " + characterData.job;
        document.getElementById("adminrank").innerText =
          "Admin Rank: " + characterData.adminrank || "UKENDT";
      });
    });
  }

  if (data.action === "close") {
    document.body.style.display = "none";
  }
});

function CharacterPressed(characterId) {
  fetch("https://nc-multichar/selectCharacter", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ characterId: characterId }),
  });
}
function CharacterDelete(characterId) {
  fetch("https://nc-multichar/deleteCharacter", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ characterId: characterId }),
  });
}

// (() => {
//   if (window.GetParentResourceName === undefined) {
//     window.dispatchEvent(
//       new MessageEvent("message", {
//         data: {
//           action: "open",
//           data: [
//             {
//               firstname: "Kian",
//               lastname: "Jones",
//               age: "31",
//             },
//           ],
//         },
//       })
//     );
//   }
// })();
