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

    public static LuaFragment newInstance() {
        Bundle args = new Bundle();
        LuaFragment fragment = new LuaFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onPause() {
        super.onPause();
        creator.onPause();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        creator.onUserVisible(isVisibleToUser);
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
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        creator.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        creator.onViewCreated(view, savedInstanceState);
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

        void onActivityCreated(Bundle savedInstanceState);

        void onViewCreated(View view, @Nullable Bundle savedInstanceState);

        void onStart();

        void onResume();

        void onStop();

        void onPause();

        void onDestroyView();

        void onDestroy();

        void onDetach();

        void onUserVisible(boolean isVisibleToUser);

    }


}
