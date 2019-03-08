document.addEventListener("DOMContentLoaded", bindButtons);

function bindButtons() {
    var tbody = document.getElementById("output").children;
    console.log(tbody);
    // add event listener to every edit button under tbody
    for(var i = 0; i < tbody.length; i++) {
        if (tbody[i].tagName === "TR") {
            var row_id = tbody[i].id;
            console.log(row_id);
            label_for_deletion(row_id);
        }
    }
}

// bind delete button
function label_for_deletion(id) {
    // get the delete button and add event listener to it
    var del = document.getElementById("delete_" + id);
    del.addEventListener("click", (event) => {
        // upon click, send a post request to delete entry from db
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/delete_game", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.addEventListener("load", () => {
            if (xhr.status >= 200 && xhr.status < 400) {
                // if successful, delete the entire tr
                var deletion_Target = document.getElementById(id);
                deletion_Target.parentNode.removeChild(deletion_Target);
            };
        });
        xhr.send(JSON.stringify({id: id}));
    });
    event.preventDefault();
};
