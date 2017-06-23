package androlua;


import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by hanks on 2017/5/26. Copyright (C) 2017 Hanks
 */

public class LuaFragment extends Fragment {

    private FragmentCreator creator;
    private boolean isPrepared;
    /**
     * 第一次onResume中的调用onUserVisible避免操作与onFirstUserVisible操作重复
     */
    private boolean isFirstResume = false;
    private boolean isFirstVisible = false;
    private boolean isFirstInvisible = false;

    public static LuaFragment newInstance() {
        Bundle args = new Bundle();
        LuaFragment fragment = new LuaFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        creator.onActivityCreated(savedInstanceState);
        initPrepare();
    }

    @Override
    public void onPause() {
        super.onPause();
        creator.onPause();
        if (getUserVisibleHint()) {
            creator.onUserInvisible();
        }
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (isFirstVisible) {
                isFirstVisible = false;
                initPrepare();
            } else {
                creator.onUserVisible();
            }
        } else {
            if (isFirstInvisible) {
                isFirstInvisible = false;
                creator.onFirstUserInvisible();
            } else {
                creator.onUserInvisible();
            }
        }
    }

    public void initPrepare() {
        if (isPrepared && isFirstVisible) {
            creator.onFirstUserVisible();
        } else {
            isPrepared = true;
        }
    }

    public void setCreator(FragmentCreator creator) {
        this.creator = creator;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        creator.onAttach(context);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        creator.onCreate(savedInstanceState);
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return creator.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        creator.onViewCreated(view, savedInstanceState);
        isPrepared = true;
    }


    @Override
    public void onStart() {
        creator.onStart();
        super.onStart();
    }

    @Override
    public void onResume() {
        creator.onResume();
        super.onResume();
        if (isFirstResume) {
            isFirstResume = false;
            return;
        }
        if (getUserVisibleHint()) {
            creator.onUserVisible();
        }
    }

    @Override
    public void onStop() {
        creator.onStop();
        super.onStop();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        creator.onDestroyView();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        creator.onDestroy();
    }

    @Override
    public void onDetach() {
        super.onDetach();
        creator.onDetach();
    }

    public interface FragmentCreator {
        void onCreate(@Nullable Bundle savedInstanceState);

        void onAttach(Context context);

        View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState);

        void onActivityCreated(@Nullable Bundle savedInstanceState);

        void onViewCreated(View view, @Nullable Bundle savedInstanceState);

        void onStart();

        void onResume();

        void onStop();

        void onDestroyView();

        void onDestroy();

        void onDetach();

        /**
         * 第一次fragment可见（进行初始化工作）
         */
        void onFirstUserVisible();

        /**
         * fragment可见（切换回来或者onResume）
         */
        void onUserVisible();

        /**
         * 第一次fragment不可见（不建议在此处理事件）
         */
        void onFirstUserInvisible();

        /**
         * fragment不可见（切换掉或者onPause）
         */
        void onUserInvisible();

        void onPause();
    }


}
