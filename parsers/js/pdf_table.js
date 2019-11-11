const path = require('path');
const fs = require('fs');
const pdf_table_extractor = require('pdf-table-extractor');

if (process.argv.length < 4) {
    return console.error('Missing arguments');
}

pdf_table_extractor(
    path.resolve(process.argv[2]),
    (result) => {
        fs.writeFileSync(path.resolve(process.argv[3]), JSON.stringify(result));
    },
    (e) => {
        console.error(e);
        process.exit(1);
    }
);