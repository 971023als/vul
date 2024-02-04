function insertData() {
    // JSON 파일 로드
    fetch('/var/www/html/results.json')
        .then(response => response.json())
        .then(data => {
            var results = data; // JSON 데이터를 가져옵니다.
            var table = document.querySelector("table");

            for (var key in results) {
                var row = table.insertRow();
                var rowData = results[key];

                var orderCell = row.insertCell(0);
                var categoryCell = row.insertCell(1);
                var severityCell = row.insertCell(2);
                var diagnosisItemCell = row.insertCell(3);
                var diagnosisResultCell = row.insertCell(4);
                var statusCell = row.insertCell(5);
                var actionCell = row.insertCell(6);
                var dateCell = row.insertCell(7);

                orderCell.innerHTML = key;
                categoryCell.innerHTML = rowData["분류"];
                severityCell.innerHTML = rowData["위험도"];
                diagnosisItemCell.innerHTML = rowData["진단 항목"];
                diagnosisResultCell.innerHTML = rowData["진단 결과"];
                statusCell.innerHTML = rowData["현황"].join("<br>");
                actionCell.innerHTML = rowData["대응방안"];
                dateCell.innerHTML = rowData["생성시간"];
            }
        })
        .catch(error => console.error('JSON 파일을 로드하는 중 오류 발생:', error));
}

window.onload = function() {
    insertData();
};