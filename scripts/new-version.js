const fs = require('fs')

let index = parseInt(process.argv[2] || '2', 10)

let pkg = require('../package')
const oldVersion = pkg.version
let vals = oldVersion.split('.')

if (index == 0) {
  vals[0]++
  vals[1] = vals[2] = 0
} else if (index == 1) {
  vals[1]++
  vals[2] = 0
} else {
  vals[2]++
}

const newVersion = vals.join('.')

pkg.version = newVersion
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n')

const src = './contracts/Authorizable.sol'
let contract = fs.readFileSync(src, 'utf-8').replace(RegExp(`\\/\\*\\* ${oldVersion} \\*\\/`), `/** ${newVersion} */`)
fs.writeFileSync(src, contract)

console.log('New version', newVersion)