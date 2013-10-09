function search_by_date(){
  var start_date = document.getElementById('start_date').value;
  var end_date = document.getElementById('end_date').value;
  if(start_date == "" || end_date == ""){
    alert("검색을 할 시작 날짜와 종료 날짜를 정확히 입력해 주십시오.");
  }
  else{
    var current_location = location.href;
    var seperated_url = current_location.split("?");
    window.location.href = seperated_url[0] + "?start_date=" + start_date + "&end_date=" + end_date;
  }
}
  

