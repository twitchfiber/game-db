// Click listener for game_plat delete function
document.addEventListener("DOMContentLoaded", bindGPButtons);

function bindGPButtons() {
    var tbody = document.getElementById("gp_search_results").children;
    // add delete button to every TR under tbody
    for(var i = 0; i < tbody.length; i++) {
        if (tbody[i].tagName === "TR") {
            var row_id = tbody[i].id;
            gp_deletion(row_id);
        }
    }
}

// bind delete button
function gp_deletion(id) {
    // get the delete button and add event listener to it
    var del = document.getElementById("delete_gp_" + id);
    var plat_id = document.getElementById("plat_id_" + id).textContent;
    del.addEventListener("click", (event) => {
        // upon click, send a post request to delete entry from db
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/delete_plat_game", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.addEventListener("load", () => {
            if (xhr.status >= 200 && xhr.status < 400) {
                // if successful, delete the entire tr
                var deletion_Target = document.getElementById(id);
                deletion_Target.parentNode.removeChild(deletion_Target);
            };
        });
        xhr.send(JSON.stringify({game_id: id, plat_id: plat_id}));
    });
    event.preventDefault();
};