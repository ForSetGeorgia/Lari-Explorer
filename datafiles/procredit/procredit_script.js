//https://apps.procreditbank.ge/CommertialExchangeRateHistory/Default.aspx
//insert jquery before executing script
// goes from first page to last page and returns ready for insert string into mysql
var res = ""
var cnt = 1
function next() {
  var cur = $('.dxp-num.dxp-current')

  if(cur.length) {
    if(cur.text() === cnt+'') {
      readTable()
      var nxt = cur.next('.dxp-num')
      if(nxt.length) { nxt.trigger('click'); next() }
      else {
        console.log('------------------------')
        console.log(res)
      }
    } else {
      setTimeout(function () { next() }, 200)
    }
  } else {
    console.log('No current page found.');
  }
}
function readTable() {
  $('.dxgvTable_DevEx tr.dxgvDataRow_DevEx').each(function (i, d) {
    var dd = $(d).children()
    var code = dd[1].innerText
    var date = dd[2].innerText
    var buy = dd[3].innerText
    var sell = dd[4].innerText

    var hour = date.substr(11,2)
    var mid = '__'
    if(['08','09','10','11'].indexOf(hour) !== -1) {
      mid = 'AM'
    } else if (['12','01','02','03','04','05','06']) {
      mid = 'PM'
    } else {
      console.log('date format error --------', code, date, buy, sell)
    }
    date = date + ' ' + mid

    // 31-10-2017 06:43 PM
    var template = "('__code__', STR_TO_DATE('__date__', '%d-%m-%Y %h:%i %p'), '__buy__', '__sell__'),\n"
    var result = template
                  .replace('__code__', code)
                  .replace('__date__', date)
                  .replace('__buy__', buy)
                  .replace('__sell__', sell)
    res += result
    // console.log(result)
  })
  ++cnt
}
next()
