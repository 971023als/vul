// JSON 데이터
// JSON 데이터를 웹 페이지에 로드하기
fetch('results.json')
.then(response => response.json())
.then(data => fillTable(data))
.catch(error => console.error('Error loading JSON data:', error));

function fillTable(data) {
    const tableBody = document.getElementById('resultsTable').getElementsByTagName('tbody')[0];
    // 데이터 객체의 각 키(진단 번호)에 대해 반복
    for (const key in data) {
        if (data.hasOwnProperty(key)) {
            const entry = data[key];
            // 각 진단 결과에 대한 테이블 행 생성
            const tr = document.createElement('tr');
            tr.innerHTML = `<td>${key}</td>
                            <td>${entry.output}</td>
                            <td>${entry.execution_time}</td>`;
            tableBody.appendChild(tr);
        }
    }
}