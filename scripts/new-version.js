const fs = require('fs')

let index = parseInt(process.argv[2] || '2', 10)

let pkg = require('../package')
const ver = pkg.version
let version = ver.split('.')

if (index == 0) {
  version[0]++
  version[1] = version[2] = 0
} else if (index == 1) {
  version[1]++
  version[2] = 0
} else {
  version[2]++
}

const newVersion = version.join('.')

pkg.version = newVersion
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2))

const src = './contracts/Authorizable.sol'
let contract = fs.readFileSync(src, 'utf-8').replace(RegExp(`\\/\\*\\* ${ver} \\*\\/`), `/** ${newVersion} */`)
fs.writeFileSync(src, contract)

console.log('New version', newVersion)