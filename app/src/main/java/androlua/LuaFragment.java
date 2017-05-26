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

    public interface  FragmentCreator{
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
    }

    public static LuaFragment newInstance() {
        Bundle args = new Bundle();
        LuaFragment fragment = new LuaFragment();
        fragment.setArguments(args);
        return fragment;
    }

    private FragmentCreator creator;

    public void setCreator(FragmentCreator creator) {
        this.creator = creator;
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


}
