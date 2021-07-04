import templates

proc styles*:string = tmpli css"""
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
    * {
        padding: 0;
        margin: 0;
    }

    body {
        background-color: #121212;
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
    }

    .note-elem {
        background-color: #232323;
        position: relative;
        display: flex;
        flex-direction: column;
        height: 280px;
        width: 280px;
        margin: 10px;
    }

    .inputfield {
        background-color: #323232;
        color: #FFFFFF;
        font-family: 'Poppins', sans-serif;
        font-weight: 400;
        border: none;
        outline: none;
    }

    .todoText {
        padding-top: 10px;
        padding-left: 10px;
        color: #FFFFFF;
        font-family: 'Poppins', sans-serif;
        font-weight: 400;
        font-size: 18px;
        height: 240px;
        border: none;
        outline: none;
        background: none;
        resize: none;
    }
    
    .dueDateText {
        color: #FFFFFF;
        font-family: 'Poppins', sans-serif;
        font-weight: 600;
        height: 36px;
        min-width: 280px;
        text-align: center;
        font-size: 22px;
    }

    button {
        display: none;
        position: absolute;
        right: 0;
        top: 0;
        width: 30px;
        height: 30px;
        background-color: #C0392B;
        outline: none;
        color: white;
        border: none;
        font-family: 'Poppins', sans-serif;
        font-weight: 600;
        font-size: 22px;
    }

    .redContainer {
        background-color: #C0392B;
    }
    
    .orangeContainer {
        background-color: #D35400;
    }
    
    .turquoiseContainer {
        background-color: #16A085;
    }

    .blueContainer {
        background-color: #2980B9;
    }

    .greenContainer {
        background-color: #27AE60;
    }

    h1 {
        color: #FFFFFF;
        font-family: 'Poppins', sans-serif;
        font-weight: 600;
        text-align: center;
    }

    #text {
        height: 240px;
        font-size: 18px;
        resize: none;
    }

    .note-elem:hover button {
        display: block;
    }
    
    #flatpickr {
        background-color: #373737;
    }
"""

export styles