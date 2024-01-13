
// main.js - System Agnostic Window Module for FoundryVTT

/**
 * Adds a button to the FoundryVTT title bar and opens a window when clicked.
 */

// Function to create the window content
function createWindowContent() {
    const div = document.createElement('div');
    div.innerHTML = '<h1>System Agnostic Window</h1><p>This is a custom window content.</p>';
    return div;
}

// Function to handle the button click and open the window
function onTitleBarButtonClick() {
    const app = new Application({
        title: 'System Agnostic Window',
        content: createWindowContent(),
        width: 400,
        height: 300
    });
    app.render(true);
}

// Hook to add the button to the title bar after FoundryVTT initialization
Hooks.once('init', () => {
    const titleBar = document.getElementById('title-bar');
    if (titleBar) {
        const button = document.createElement('button');
        button.innerText = 'Open Window';
        button.addEventListener('click', onTitleBarButtonClick);
        titleBar.appendChild(button);
    }
});
