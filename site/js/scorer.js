var table = document.querySelector(".mdc-table");

function registerScore(score) {
  var row = document.createElement("tr");
  var cell1 = document.createElement("td");
  cell1.textContent = "Shot " + (table.rows.length + 1);
  var cell2 = document.createElement("td");
  cell2.textContent = score;
  row.appendChild(cell1);
  row.appendChild(cell2);
  table.appendChild(row);
}

document.querySelector(".mdc-button").addEventListener("click", function() {
  registerScore(10);
});