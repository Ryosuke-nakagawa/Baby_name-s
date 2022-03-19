document.addEventListener("DOMContentLoaded", function(){
      // チャートデータ
  const data = {
    labels: ['天格', '人格', '地格', '外格', '総格', '三才配置'],
    datasets: [{
      label: gon.full_name,
      data: [ gon.first_name.fortune_telling_heaven, gon.first_name.fortune_telling_person, gon.first_name.fortune_telling_land, gon.first_name.fortune_telling_outside, gon.first_name.fortune_telling_all, gon.first_name.fortune_telling_talent ]
    }]}
  // グラフを描画
  const ctx = document.getElementById('chart')
  Chart.defaults.global.defaultFontColor = '#4f342c';
  Chart.defaults.global.defaultFontSize = 15;
  Chart.defaults.global.defaultFontFamily = 'sans-serif';
  const chart = new Chart(ctx, {
    type: 'radar', // グラフの種類
    data: data, // データ
    options: {
            plugins: {
              colorschemes: {
                scheme: 'brewer.YlOrRd3'
              }
            },
            scale:{
                ticks:{
                    suggestedMin: 0,
                    suggestedMax: 50,
                    stepSize: 10,
                    min: 0,
                    callback: function(value, index, values){
                        let str = 'undifined'
                        switch (value) {
                          case 50:
                            str = '大吉'
                            break;
                          case 40:
                            str = '吉'
                            break;
                          case 30:
                            str = '特殊格'
                            break;
                          case 20:
                            str = '吉凶混合'
                            break;
                          case 10:
                            str = '凶'
                        }
                        return str
                      }
                    }
                }
      }
  }) // オプション
 
})