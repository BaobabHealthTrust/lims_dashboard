

function GetClock(){
    var d=new Date();
    var nday=d.getDay(),nmonth=d.getMonth(),ndate=d.getDate(),nyear=d.getYear(),nhour=d.getHours(),nmin=d.getMinutes(),nsec=d.getSeconds(),ap;
    var month=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    if(nhour==0){ap=" AM";nhour=12;}
    else if(nhour<12){ap=" AM";}
    else if(nhour==12){ap=" PM";}
    else if(nhour>12){ap=" PM";nhour-=12;}

    if(nyear<1000) nyear+=1900;
    if(nmin<=9) nmin="0"+nmin;
    if(nsec<=9) nsec="0"+nsec;

    document.getElementById('clockbox').innerHTML=""+ndate+" "+month[nmonth]+" "+nyear+" "+nhour+":"+nmin+":"+nsec+ap+"";
}

function reloadTable(section, data, keys, container)
{
    if (container.trim() == "" )
    {
        container = "main";
    }
    var table = document.getElementById(section);
    var html = "";
    var count = 0;
    constant = document.getElementById('heading').offsetHeight + document.getElementById('summary').offsetHeight;
    var height = document.getElementById('heading').offsetHeight + document.getElementById('summary').offsetHeight;
    var maxHeight = document.getElementById(container).offsetHeight
    while (table.hasChildNodes()) {
        table.removeChild(table.lastChild);
    }

    for( i=0 ; i < data.length ; i++)
    {
        if ((table.offsetHeight + constant + 50 ) < maxHeight) {
            html =  "<div style='display: table-row' class='"+ ((i % 2 == 0) ? 'odd' : 'even') +"'>"
            for(w = 0; w < keys.length ; w++)
            {
                console.log(keys[w]);
                if (['action'].indexOf(keys[w][0]) != -1)
                {
                    if (Array.isArray(data[i][keys[w][0]]))
                    {
                        html = html + "<div class='base-cell' style=" +(isNaN(parseFloat(keys[w][1])) ? '' : 'width:'+keys[w][1] +'%')+">" +
                            drawProgressBar(data[i][keys[w][0]][1]) +"</div>"
                    }
                    else{
                        html = html + "<div class='base-cell' style=" +(isNaN(parseFloat(keys[w][1])) ? '' : 'width:'+keys[w][1] +'%;text-align:'+keys[w][2])+">"+
                            data[i][keys[w][0]] +"</div>"
                    }
                }
                else
                {
                    html = html + "<div class='base-cell' style=" +(isNaN(parseFloat(keys[w][1])) ? '' : 'width:'+keys[w][1] +'%;text-align:'+keys[w][2])+">"+
                        data[i][keys[w][0]] +"</div>"
                }
            }
            html += "</div>"
            table.innerHTML += html
        }
        else
        {
            break;
        }
        count += 1
    }

    document.getElementById('summary').innerHTML = "<b>Showing</b> " + count + " / " + data.length

}

function getData(link)
{
    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    }else{// code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            var results = xmlhttp.responseText;
            if(results == 'undefined' || results == '' || results == 'null' || results == '"not validate"') {
                return ;
            }else if(results.length > 0){
                handleResults(JSON.parse(results))
            }else{
                return ;
            }
        }
    }
    xmlhttp.open("GET",link ,true);
    xmlhttp.send();

}

function drawProgressBar(width)
{

    return "<div id='progressbar'>" + '<div style="width:'+width+'%; background-color:'+
        (width > 70 ? '#119922' : (width > 40 ? '#FFFF00' : '#CC0000')) +'"></div>' + "</div>"

}
function getStats(path)
{
    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    }else{// code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            var statistics = xmlhttp.responseText;
            if(statistics == 'undefined' || statistics == '' || statistics == 'null' || statistics == '"not validate"') {
                return ;
            }else if(statistics.length > 0){
                stats = JSON.parse(statistics)
                document.getElementById('ordered').innerHTML =  stats["Drawn"];
                document.getElementById('received').innerHTML =  stats["Received At Reception"]
                document.getElementById('tested').innerHTML =  stats["Tested"]
                document.getElementById('pending').innerHTML =  stats["Received In Department"]
                document.getElementById('turn-around').innerHTML =  stats["avg_tat_in_min"] + " mins"
                updateRecords();
            }else{
                return ;
            }
        }
    }
    xmlhttp.open("GET",path ,true);
    xmlhttp.send();

}