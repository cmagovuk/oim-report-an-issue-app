document.addEventListener('DOMContentLoaded', () => {
    var alreadyClicked = false;

    onceClicked = (e) => {
        if (alreadyClicked) {
            e.preventDefault();
            return false;
        }
        alreadyClicked = true;
    };

    const inputFileUpload = document.getElementsByClassName("upload-input")[0];
    const uploadFileButton = document.getElementsByClassName("upload-files-button")[0];
    const continueButton = document.getElementsByClassName("upload-continue-button")[0];
    const submissionButton = document.getElementsByClassName("oim-submission-button")[0];

    if (inputFileUpload && continueButton && uploadFileButton) {
        inputFileUpload.addEventListener('change', (e) => {
            if (continueButton) {
                continueButton.disabled = true;
            }
            inputFileUpload.form.submit();
            inputFileUpload.disabled = true;
        });

        uploadFileButton.style.display = "none";
    }

    if (submissionButton) {
        submissionButton.addEventListener('click', onceClicked);
        addEventListener('pageshow', (e) => {
            alreadyClicked = false;
        });
    }
});
