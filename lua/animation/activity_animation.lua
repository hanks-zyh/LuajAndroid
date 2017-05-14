require("import")
import("android.content.*")
import("android.widget.*")
import "android.view.View"

local layout = {
  FrameLayout,
  layout_width="fill",
  layout_height="fill",
  {
    Button,
    text="button1",
    id="view1",
    layout_width="100dp",
    layout_height="50dp",
  },
  {
    Button,
    id="view2",
    text="button2",
    layout_width="100dp",
    layout_height="50dp",
    layout_marginLeft = "100dp",
    layout_marginTop = "80dp",
  }
}

function onCreate( savedInstanceState )
  activity.setTitle('Test Animation')
  activity.setContentView(loadlayout(layout))
  view1.onClick = function ( v )
     view1.animate().translationX(500).setDuration(3000).start();
  end
  view2.onClick = function ( v )
     view2.animate().scaleX(2).scaleY(2).setDuration(3000).start();
  end
end