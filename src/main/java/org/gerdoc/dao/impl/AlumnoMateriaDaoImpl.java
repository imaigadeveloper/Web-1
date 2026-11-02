package org.gerdoc.dao.impl;

import org.gerdoc.dao.AlumnoMateriaDao;
import org.gerdoc.model.AlumnoMateria;
import org.gerdoc.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class AlumnoMateriaDaoImpl implements AlumnoMateriaDao
{
    private Session session;

    private void getSession()
    {
        if (session == null || !session.isOpen())
        {
            session = HibernateUtil.getSessionFactory().openSession();
        }
    }

    @Override
    public List<AlumnoMateria> findAll()
    {
        getSession();
        CriteriaBuilder builder = session.getCriteriaBuilder();

        CriteriaQuery<AlumnoMateria> criteria =
                builder.createQuery(AlumnoMateria.class);
        criteria.from(AlumnoMateria.class);
        return session
                .createQuery(criteria)
                .getResultList();
    }

    @Override
    public AlumnoMateria findById(Long id)
    {
        getSession();
        return session.get( AlumnoMateria.class, id );
    }

    @Override
    public AlumnoMateria save(AlumnoMateria alumnoMateria)
    {
        getSession();
        Transaction transaction = null;
        try
        {
            transaction = session.beginTransaction();
            session.save( alumnoMateria );
            transaction.commit( );
            return alumnoMateria;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            if (transaction != null)
            {
                transaction.rollback( );
            }
            return null;
        }
    }

    @Override
    public void deleteById(Long id)
    {
        getSession();
        Transaction transaction = null;
        AlumnoMateria alumnoMateria = null;
        try
        {
            alumnoMateria = findById( id );
            if( alumnoMateria != null )
            {
                transaction = session.beginTransaction();
                session.delete( alumnoMateria );
                transaction.commit( );
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            if (transaction != null)
            {
                transaction.rollback( );
            }
        }
    }

    @Override
    public AlumnoMateria update(AlumnoMateria alumnoMateria)
    {
        getSession();
        Transaction transaction = null;
        AlumnoMateria updatedAlumnoMateria = null;
        try
        {
            transaction = session.beginTransaction();
            updatedAlumnoMateria = (AlumnoMateria) session.merge( alumnoMateria );
            transaction.commit( );
            return updatedAlumnoMateria;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            if (transaction != null)
            {
                transaction.rollback( );
            }
            return null;
        }
    }
}