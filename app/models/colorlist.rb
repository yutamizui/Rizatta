class Colorlist < ActiveHash::Base
  self.data = [
    {id: 1, name: "赤(Red)", code: "#B22222"}, {id: 2, name: "青(Blue)", code: "#1E90FF"}, {id: 3, name: "緑(Green)", code: "#228B22"},
    {id: 4, name: "黄色(Yellow)", code: "#FFD700"},  {id: 5, name: "オレンジ(Orange)", code: "#FFA500"}, {id: 6, name: "ピンク(Pink)", code: "#EE82EE"},
    {id: 7, name: "灰色(Gray)", code: "#808080"}, {id: 8, name: "茶色(Brown)", code: "#A0522D"}
  ]
end

