const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();

app.use(fileUpload())
app.use('/images/profile', express.static('images/profile'))

app.post('/upload', function(req, res) {
    let uploadFile;
    let uploadPath;
    
    uploadFile = req.files?.picture
    uploadPath = __dirname + '/images/profile/' + uploadFile.name;

    uploadFile.mv(uploadPath, function(err) {
        if (err) return res.status(500).send(err)
        res.send('/images/profile/' + uploadFile.name)
    });
});

app.listen(3000, function() {
    return console.log('Started file uploader server on port ' + 3000);
})