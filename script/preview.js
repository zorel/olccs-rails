var page = new WebPage(), address, output, size, png, pdf;
if (phantom.args.length < 1) {
    console.log('Usage: rasterize.js URL filename');
    phantom.exit();
} else {
    address = phantom.args[0];
    png = "site.png";
    pdf = "site.pdf";
    page.viewportSize = { width: 1024, height: 768 };
    page.open(address, function (status) {
            if (status === 'success') {
            window.setTimeout(function () {
                page.render(png);
                page.render(pdf);
                phantom.exit();
            }, 10000);
        } else {
            console.log('Unable to load the address!');
        }
    });
}
