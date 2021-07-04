import templates

proc script(): string = tmpli js"""
    function deleteItem(id) {
        axios({
        method: 'post',
        url: '/deleteItem',
        data: {
            id: id
        }
        }).then(function (response) {
            console.log(response);
            window.location.reload();
        }).catch(function (error) {
            console.log(error);
        })
    }

    function addItem() {
        var todoDesc = document.getElementById("text").value;
        var todoDate = document.getElementById("flatpickr").value;
        axios({
        method: 'post',
        url: '/addItem',
        data: {
            desc: todoDesc,
            date: todoDate
        }
        }).then(function (response) {
            console.log(response);
            document.getElementById("text").value = "";
            document.getElementById("flatpickr").value = "";
            window.location.reload();
        }).catch(function (error) {
            console.log(error);
            window.location.reload();
        })
    }

    const inputs = document.getElementsByClassName("inputfield")
    inputs[0].addEventListener("keyup", ({key}) => {
        if (key == "Enter") {
            addItem();
        }
    });
    inputs[1].addEventListener("keyup", ({key}) => {
        if (key == "Enter") {
            addItem();
        }
    });

    var example = flatpickr('#flatpickr', {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        time_24hr: true
    });

    console.log("Test");
"""

export script
